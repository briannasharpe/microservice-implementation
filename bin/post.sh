#!/bin/sh

# === users service ===
# create a user
http --verbose POST http://localhost:5000/users/ username='merchbot' email='merchbot@exoplanet.com' password='money$$$'
http --verbose POST http://localhost:5000/users/ username='merchbot' email='merchbot@exoplanet.com' password='money$$$'
http --verbose POST http://localhost:5000/users/ username='not_merchbot' email='merchbot@exoplanet.com' password='money$$$'

# check password
# http --verbose POST http://localhost:5000/users/check/ username='merchbot' password='money$$$'
# http --verbose POST http://localhost:5000/users/check/ username='merchbot' password='money$$$1'

# http --verbose POST http://localhost:5000/users/merchbot/check/ password='money$$$'
# http --verbose POST http://localhost:5000/users/merchbot/check/ password='money$$$1'

# add follower
http --verbose POST http://localhost:5000/users/merchbot/follows/baekhyunee_exo/
http --verbose POST http://localhost:5000/users/merchbot/follows/baekhyunee_exo/

# remove follower
http --verbose DELETE http://localhost:5000/users/merchbot/follows/baekhyunee_exo/
http --verbose DELETE http://localhost:5000/users/merchbot/follows/baekhyunee_exo/


# === timelines service ===
# get user timeline
http --verbose GET http://localhost:5100/timelines/baekhyunee_exo/

# get public timeline
http --verbose GET http://localhost:5100/timelines/

# get home timeline
http --verbose GET http://localhost:5100/timelines/baekhyunee_exo/home/

# post tweet
# http --verbose POST http://localhost:5100/timelines/posts/ username='merchbot' text='money'