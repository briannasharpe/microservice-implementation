# Microblogging Service (Timeline API)
#
# Adapted from "Creating Web APIs with Python and Flask"
# <https://programminghistorian.org/en/lessons/creating-apis-with-python-and-flask>.
#

import sys
import textwrap
import logging.config
import sqlite3

import bottle
from bottle import get, post, error, abort, request, response, HTTPResponse
from bottle.ext import sqlite
from datetime import datetime

# Set up app, plugins, and logging
#
app = bottle.default_app()
app.config.load_config('./etc/timeline_api.ini')

plugin = sqlite.Plugin(app.config['sqlite.dbfile'])
app.install(plugin)

logging.config.fileConfig(app.config['logging.config'])


# Return errors in JSON
#
# Adapted from # <https://stackoverflow.com/a/39818780>
#
def json_error_handler(res):
    if res.content_type == 'application/json':
        return res.body
    res.content_type = 'application/json'
    if res.body == 'Unknown Error.':
        res.body = bottle.HTTP_CODES[res.status_code]
    return bottle.json_dumps({'error': res.body})


app.default_error_handler = json_error_handler

# Disable warnings produced by Bottle 0.12.19.
#
#  1. Deprecation warnings for bottle_sqlite
#  2. Resource warnings when reloader=True
#
# See
#  <https://docs.python.org/3/library/warnings.html#overriding-the-default-filter>
#
if not sys.warnoptions:
    import warnings
    for warning in [DeprecationWarning, ResourceWarning]:
        warnings.simplefilter('ignore', warning)


# Simplify DB access
#
# Adapted from
# <https://flask.palletsprojects.com/en/1.1.x/patterns/sqlite3/#easy-querying>
#
def query(db, sql, args=(), one=False):
    cur = db.execute(sql, args)
    rv = [dict((cur.description[idx][0], value)
          for idx, value in enumerate(row))
          for row in cur.fetchall()]
    cur.close()

    return (rv[0] if rv else None) if one else rv


def execute(db, sql, args=()):
    cur = db.execute(sql, args)
    id = cur.lastrowid
    cur.close()

    return id


# Routes

@get('/')
def home():
    return textwrap.dedent('''
        <h1>Twotter</h1>
        <p>A microblogging service.</p>\n
    ''')

# getUserTimeline(username)
# Returns recent posts from a user.
@get('/timelines/<username>/')
def getUserTimeline(db, username):
    try:
        timeline = query(db, '''
            SELECT * FROM posts 
            WHERE username = :username 
            ORDER BY created DESC LIMIT 25;
            ''', [username])
    except sqlite3.IntegrityError as e:
        abort(409, str(e))

    response.content_type = 'application/json'
    response.status = 200
    return { username + "'s timeline" : timeline }

# getPublicTimeline()
# Returns recent posts from all users.
@get('/timelines/')
def getUserTimeline(db):
    try:
        timeline = query(db, '''
            SELECT * FROM posts 
            ORDER BY created DESC LIMIT 25;
            ''')
    except sqlite3.IntegrityError as e:
        abort(409, str(e))

    response.content_type = 'application/json'
    response.status = 200
    return { "Public timeline" : timeline }

# getHomeTimeline(username)
# Returns recent posts from all users that this user follows.
@get('/timelines/<username>/home/')
def getHomeTimeline(db, username):
    try:
        timeline = query(db, '''
            SELECT * FROM posts
            WHERE username 
            IN (SELECT usernameToFollow FROM follows 
                WHERE username = :username)
            ORDER BY created DESC 
            LIMIT 25;
            ''', [username])
    except sqlite3.IntegrityError as e:
        abort(409, str(e))

    response.content_type = 'application/json'
    response.status = 200
    return { "Home timeline for " + username : timeline }

# postTweet(username, text)
# Post a new tweet.
@post('/timelines/posts/')
def postTweet(db):
    post = request.json

    if not post:
        abort(400)

    posted_fields = post.keys()
    required_fields = {'username', 'text'}

    if not required_fields <= posted_fields:
        abort(400, f'Missing fields: {required_fields - posted_fields}')
    
    try:
        created = datetime.utcnow()
        execute(db, '''
            INSERT INTO posts(username, text, created)
            VALUES(:username, :text, :created)
            ''', [created])
        response.content_type = 'application/json'
        response.status = 201
        return post
    except sqlite3.IntegrityError as e:
        abort(409, str(e))