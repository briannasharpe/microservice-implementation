#!/bin/sh

# rm ./var/users.db ./var/timelines.db
sqlite3 ./var/users.db < ./share/users.sql
sqlite3 ./var/timelines.db < ./share/timelines.sql