# Microblogging Service Implementation
Brianna Sharpe

## Description
This project includes shell files (`init.sh, post.sh`), misc files (`logging.ini, timeline_api.ini, user_api.ini, api.log`), SQL files (`timelines.sql, users.sql`), python files (`timeline_api.py, user_api.py`), and the `Procfile`.

**Shortcomings:** The timelines database includes the tables created in the users database because I didn't know how to properly reference the tables in `users.db` as a separate database. This means requests for any newly created users will not work with the timeline api. The requests for `checkPassword` and `postTweet` do not work.

## How to run the code
### 1. Build the databases
```
./bin/init.sh
```

### 2. Start the microservice
```
foreman start
```

### 3. In another terminal, run the sample HTTP requests
```
./bin/post.sh
```
This command will run all the working http requests for both users and timelines services. Some requests show up multiple times to show that duplicate records are not allowed.

## HTTP requests (working parts)
Request                                                                | Description
---------------------------------------------------------------------- | ----------------------------------------
`http POST http://localhost:5000/users/ username=? email=? password=?` | Registers a new user account.
`http POST http://localhost:5000/users/user1/follows/user2/`           | Starts following user.
`http DELETE http://localhost:5000/users/user1/follows/user2/`         | Stops following user.
`http GET http://localhost:5100/timelines/user/`                       | Returns recent posts from a user.
`http GET http://localhost:5100/timelines/`                            | Returns recent posts from all users.
`http GET http://localhost:5100/timelines/user/home/`                  | Returns recent posts from all users that a specified user follows.
