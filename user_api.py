# Microblogging Service (User API)
#
# Adapted from "Creating Web APIs with Python and Flask"
# <https://programminghistorian.org/en/lessons/creating-apis-with-python-and-flask>.
#

import sys
import textwrap
import logging.config
import sqlite3

import bottle
from bottle import get, post, delete, error, abort, request, response, HTTPResponse
from bottle.ext import sqlite

# Set up app, plugins, and logging
#
app = bottle.default_app()
app.config.load_config('./etc/user_api.ini')

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

# createUser(username, email, password)
# Registers a new user account. Returns true if username is available, email address is valid, and password meets complexity requirements.
@post('/users/')
def createUser(db):
    user = request.json

    if not user:
        abort(400)

    posted_fields = user.keys()
    required_fields = {'username', 'email', 'password'}

    if not required_fields <= posted_fields:
        abort(400, f'Missing fields: {required_fields - posted_fields}')

    try:
        check_user = query(db, 'SELECT * FROM users WHERE username = :username;', [user['username']])
        if check_user:
            abort(400, "That username has been taken. Please choose another.")

        check_email = query(db, 'SELECT * FROM users WHERE email = :email;', [user['email']])
        if check_email:
            abort(400, "Email already in use.")

        execute(db, '''
            INSERT INTO users(username, email, password)
            VALUES(:username, :email, :password)
            ''', user)
    except sqlite3.IntegrityError as e:
        abort(409, str(e))
    
    response.content_type = 'application/json'
    response.status = 201
    return user

# checkPassword(username, password)
# Returns true if the password parameter matches the password stored for the username
@post('/users/<username>/check/')
def checkPassword(db, username):
    user = request.json

    if not user:
        abort(400)

    posted_fields = user.keys()
    required_fields = {'password'}
    
    if not required_fields <= posted_fields:
        abort(400, f'Missing fields: {required_fields - posted_fields}')
    
    try:
        password = query(db, 'SELECT password FROM users WHERE username = :username;', [username])
        if password != user['password']:
            abort(400, "The username and password did not match our records. Please double-check and try again.")

        response.content_type = 'application/json'
        response.status = 200
        return True
    except sqlite3.IntegrityError as e:
        abort(409, str(e))

# addFollower(username, usernameToFollow)
# Start following a new user.
@post('/users/<username>/follows/<usernameToFollow>/')
def addFollower(db, username, usernameToFollow):
    try:
        following = query(db, 'SELECT usernameToFollow FROM follows WHERE username = :username;', [username], one=True)
        
        if following:
            abort(409, f'{username} already follows {usernameToFollow}')
        else:
            execute(db, '''
                INSERT INTO follows(username, usernameToFollow)
                VALUES(:username, :usernameToFollow)
                ''', [username, usernameToFollow])
            response.content_type = 'application/json'
            response.status = 201
            return { "added to " + username + "'s following list": usernameToFollow }
    except sqlite3.IntegrityError as e:
        abort(409, str(e))
    
# removeFollower(username, usernameToRemove)
# Stop following a user.
@delete('/users/<username>/follows/<usernameToRemove>/')
def removeFollower(db, username, usernameToRemove):
    try:
        following = query(db, 'SELECT usernameToFollow FROM follows WHERE username = :username;', [username], one=True)
        
        if following:
            execute(db, '''
                DELETE FROM follows WHERE username = :username AND usernameToFollow = :usernameToRemove;
                ''', [username, usernameToRemove])
            response.content_type = 'application/json'
            response.status = 202
            return { "removed from " + username + "'s following list": usernameToRemove }
        else:
            abort(409, f'{username} does not follow {usernameToRemove}')
    except sqlite3.IntegrityError as e:
        abort(409, str(e))