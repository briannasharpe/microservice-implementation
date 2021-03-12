-- $ sqlite3 timelines.db < timelines.sql

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

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
    username VARCHAR,
    text VARCHAR,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (username) REFERENCES users(username)
);

INSERT INTO posts(username, text, created) VALUES('baekhyunee_exo', '에리들 사랑하고 고마워 이 겨울이 끝나기 전에 또 보고싶다 열심히 준비해서 또 나올게 !', '2021-01-10 05:11:28');
INSERT INTO posts(username, text, created) VALUES('baekhyunee_exo', '라이브를준비해볼까', '2021-02-15 00:38:02');
INSERT INTO posts(username, text, created) VALUES('real__pcy', '천재견 인정', '2020-10-01 16:42:08');
INSERT INTO posts(username, text, created) VALUES('real__pcy', '앞으로 삼십분!! 미우치아프라다와 라프시먼스가 공동으로 크리에이티브 디렉터로 참여한 첫번째 패션쇼', '2020-09-24 10:02:30');
INSERT INTO posts(username, text, created) VALUES('oohsehun', 'super matcha kit #수퍼말차 #porecare #skincarekit #미라클처럼 보송촉촉 #광고', '2021-02-25 21:21:21');
/* INSERT INTO posts(username, text, created) VALUES('', '', ''); */

COMMIT;
