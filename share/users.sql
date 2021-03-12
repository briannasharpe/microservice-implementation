-- $ sqlite3 users.db < users.sql

PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    username VARCHAR,
    email VARCHAR,
    password VARCHAR,

    PRIMARY KEY (username),
    UNIQUE (username, email)
);

INSERT INTO users(username, email, password) VALUES('baekhyunee_exo', 'exolnaeggo@exoplanet.com', 'baekhyun4');
INSERT INTO users(username, email, password) VALUES('kimjongdae', 'bossbellkim@exoplanet.com', 'chenchen');
INSERT INTO users(username, email, password) VALUES('real__pcy', 'loeygotothespacenow@exoplanet.com', 'chanyeol61');
INSERT INTO users(username, email, password) VALUES('zkdlin', 'zkdlin@exoplanet.com', 'jongin:)');
INSERT INTO users(username, email, password) VALUES('oohsehun', 'ohvivi@exoplanet.com', 'monsieur412');
INSERT INTO users(username, email, password) VALUES('e_xiu_o', 'xiuweetime@exoplanet.com', 'minseok');
INSERT INTO users(username, email, password) VALUES('kimjuncotton', 'cotton@exoplanet.com', 'junmyeon0522');
INSERT INTO users(username, email, password) VALUES('layzhang', 'iamthesheep@exoplanet.com', 'yixing1111');
INSERT INTO users(username, email, password) VALUES('dokyungsoo', 'dokyungsoo@exoplanet.com', 'kyungsoo');
/* INSERT INTO users(username, email, password) VALUES('', '', ''); */

DROP TABLE IF EXISTS follows;
CREATE TABLE follows (
    username VARCHAR,
    usernameToFollow VARCHAR,

    FOREIGN KEY (username) REFERENCES users(username),
    FOREIGN KEY (usernameToFollow) REFERENCES users(username)
);

INSERT INTO follows(username, usernameToFollow) VALUES('baekhyunee_exo', 'real__pcy');
INSERT INTO follows(username, usernameToFollow) VALUES('baekhyunee_exo', 'oohsehun');
INSERT INTO follows(username, usernameToFollow) VALUES('baekhyunee_exo', 'kimjongdae');
INSERT INTO follows(username, usernameToFollow) VALUES('baekhyunee_exo', 'dokyungsoo');
INSERT INTO follows(username, usernameToFollow) VALUES('kimjongdae', 'e_xiu_o');
INSERT INTO follows(username, usernameToFollow) VALUES('kimjongdae', 'baekhyunee_exo');
INSERT INTO follows(username, usernameToFollow) VALUES('real__pcy', 'baekhyunee_exo');
INSERT INTO follows(username, usernameToFollow) VALUES('real__pcy', 'oohsehun');
INSERT INTO follows(username, usernameToFollow) VALUES('real__pcy', 'dokyungsoo');
INSERT INTO follows(username, usernameToFollow) VALUES('zkdlin', 'oohsehun');
INSERT INTO follows(username, usernameToFollow) VALUES('zkdlin', 'dokyungsoo');
INSERT INTO follows(username, usernameToFollow) VALUES('oohsehun', 'baekhyunee_exo');
INSERT INTO follows(username, usernameToFollow) VALUES('oohsehun', 'real__pcy');
INSERT INTO follows(username, usernameToFollow) VALUES('oohsehun', 'kimjuncotton');
INSERT INTO follows(username, usernameToFollow) VALUES('oohsehun', 'dokyungsoo');
INSERT INTO follows(username, usernameToFollow) VALUES('oohsehun', 'zkdlin');
INSERT INTO follows(username, usernameToFollow) VALUES('e_xiu_o', 'kimjongdae');
INSERT INTO follows(username, usernameToFollow) VALUES('kimjuncotton', 'oohsehun');
INSERT INTO follows(username, usernameToFollow) VALUES('kimjuncotton', 'zkdlin');
INSERT INTO follows(username, usernameToFollow) VALUES('kimjuncotton', 'layzhang');
INSERT INTO follows(username, usernameToFollow) VALUES('layzhang', 'baekhyunee_exo');
INSERT INTO follows(username, usernameToFollow) VALUES('layzhang', 'real__pcy');
INSERT INTO follows(username, usernameToFollow) VALUES('layzhang', 'kimjuncotton');
INSERT INTO follows(username, usernameToFollow) VALUES('dokyungsoo', 'oohsehun');
INSERT INTO follows(username, usernameToFollow) VALUES('dokyungsoo', 'real__pcy');
INSERT INTO follows(username, usernameToFollow) VALUES('dokyungsoo', 'baekhyunee_exo');
INSERT INTO follows(username, usernameToFollow) VALUES('dokyungsoo', 'zkdlin');
/* INSERT INTO follows(username, usernameToFollow) VALUES('', ''); */

COMMIT;