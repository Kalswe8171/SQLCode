ALTER TABLE PRODUCTLIST
ADD (
    PRICE NUMBER(8,2),
    DESCRIPTION VARCHAR2(250)
);



UPDATE PRODUCTLIST p
SET p.PRICE =
(
    SELECT s.PRICE
    FROM STOREFRONT s
    WHERE s.PRODUCTCODE = p.PRODUCTCODE
)
WHERE EXISTS
(
    SELECT 1
    FROM STOREFRONT s
    WHERE s.PRODUCTCODE = p.PRODUCTCODE
);



UPDATE PRODUCTLIST p
SET p.DESCRIPTION =
(
    SELECT s.DESCRIPTION
    FROM STOREFRONT s
    WHERE s.PRODUCTCODE = p.PRODUCTCODE
)
WHERE EXISTS
(
    SELECT 1
    FROM STOREFRONT s
    WHERE s.PRODUCTCODE = p.PRODUCTCODE
);



COMMIT;



DROP TABLE STOREFRONT;



SELECT PRODUCTCODE,
       PRICE,
       DESCRIPTION
FROM PRODUCTLIST
ORDER BY PRODUCTCODE;




CREATE TABLE CHATLOG
(
    CHATID NUMBER(3),
    RECEIVERID NUMBER(3),
    SENDERID NUMBER(3),
    DATESENT DATE,
    CONTENT VARCHAR2(250),

    CONSTRAINT CHATLOG_PK
        PRIMARY KEY (CHATID),

    CONSTRAINT CHATLOG_RECEIVER_FK
        FOREIGN KEY (RECEIVERID)
        REFERENCES USERBASE(USERID),

    CONSTRAINT CHATLOG_SENDER_FK
        FOREIGN KEY (SENDERID)
        REFERENCES USERBASE(USERID)
);



INSERT INTO CHATLOG
    (CHATID, RECEIVERID, SENDERID, DATESENT, CONTENT)
SELECT RN,
       RECEIVERID,
       SENDERID,
       SYSDATE - RN,
       'Sample chat message number ' || RN
FROM
(
    SELECT
        u1.USERID AS SENDERID,
        u2.USERID AS RECEIVERID,
        ROW_NUMBER() OVER
        (
            ORDER BY u1.USERID, u2.USERID
        ) AS RN
    FROM USERBASE u1
    CROSS JOIN USERBASE u2
    WHERE u1.USERID <> u2.USERID
)
WHERE RN <= 10;


COMMIT;


SELECT *
FROM CHATLOG
ORDER BY CHATID;




CREATE TABLE FRIENDSLIST
(
    USERID NUMBER(3),
    FRIENDID NUMBER(3),

    CONSTRAINT FRIENDSLIST_PK
        PRIMARY KEY (USERID, FRIENDID),

    CONSTRAINT FRIENDSLIST_USER_FK
        FOREIGN KEY (USERID)
        REFERENCES USERBASE(USERID),

    CONSTRAINT FRIENDSLIST_FRIEND_FK
        FOREIGN KEY (FRIENDID)
        REFERENCES USERBASE(USERID)
);




INSERT INTO FRIENDSLIST
    (USERID, FRIENDID)
SELECT USERID,
       FRIENDID
FROM
(
    SELECT
        u1.USERID AS USERID,
        u2.USERID AS FRIENDID,
        ROW_NUMBER() OVER
        (
            ORDER BY u1.USERID, u2.USERID
        ) AS RN
    FROM USERBASE u1
    CROSS JOIN USERBASE u2
    WHERE u1.USERID <> u2.USERID
)
WHERE RN <= 10;



COMMIT;



SELECT *
FROM FRIENDSLIST
ORDER BY USERID, FRIENDID;






CREATE TABLE WISHLIST
(
    USERID NUMBER(3),
    PRODUCTCODE VARCHAR2(5),
    POSITION NUMBER(3),

    CONSTRAINT WISHLIST_PK
        PRIMARY KEY (USERID, PRODUCTCODE),

    CONSTRAINT WISHLIST_USER_FK
        FOREIGN KEY (USERID)
        REFERENCES USERBASE(USERID),

    CONSTRAINT WISHLIST_PRODUCT_FK
        FOREIGN KEY (PRODUCTCODE)
        REFERENCES PRODUCTLIST(PRODUCTCODE)
);




INSERT INTO WISHLIST
    (USERID, PRODUCTCODE, POSITION)
SELECT USERID,
       PRODUCTCODE,
       RN
FROM
(
    SELECT
        u.USERID,
        p.PRODUCTCODE,
        ROW_NUMBER() OVER
        (
            ORDER BY u.USERID, p.PRODUCTCODE
        ) AS RN
    FROM USERBASE u
    CROSS JOIN PRODUCTLIST p
)
WHERE RN <= 10;


COMMIT;



SELECT *
FROM WISHLIST
ORDER BY USERID, POSITION;





CREATE TABLE USERPROFILE
(
    USERID NUMBER(3),
    IMAGEFILE VARCHAR2(250),
    DESCRIPTION VARCHAR2(250),

    CONSTRAINT USERPROFILE_PK
        PRIMARY KEY (USERID),

    CONSTRAINT USERPROFILE_USER_FK
        FOREIGN KEY (USERID)
        REFERENCES USERBASE(USERID)
);



INSERT INTO USERPROFILE
    (USERID, IMAGEFILE, DESCRIPTION)
SELECT USERID,
       '/images/profiles/user_' || USERID || '.jpg',
       'This is the About Me profile for user ' || USERID
FROM
(
    SELECT USERID,
           ROW_NUMBER() OVER (ORDER BY USERID) AS RN
    FROM USERBASE
)
WHERE RN <= 10;


COMMIT;



SELECT *
FROM USERPROFILE
ORDER BY USERID;




CREATE TABLE SECURITYQUESTION
(
    QUESTIONID NUMBER,
    USERID NUMBER(3),
    QUESTION VARCHAR2(250),
    ANSWER VARCHAR2(250),

    CONSTRAINT SECURITYQUESTION_PK
        PRIMARY KEY (QUESTIONID),

    CONSTRAINT SECURITYQUESTION_USER_FK
        FOREIGN KEY (USERID)
        REFERENCES USERBASE(USERID)
);



INSERT ALL

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        1,
        (SELECT MIN(USERID) FROM USERBASE),
        'What city were you born in?',
        'Richmond'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        2,
        (SELECT MIN(USERID) FROM USERBASE),
        'What was the name of your first pet?',
        'Buddy'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        3,
        (SELECT MIN(USERID) FROM USERBASE),
        'What is your favorite color?',
        'Blue'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        4,
        (SELECT MIN(USERID) FROM USERBASE),
        'What was the name of your first school?',
        'Central School'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        5,
        (SELECT MIN(USERID) FROM USERBASE),
        'What is your favorite game?',
        'VaporGames'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        6,
        (SELECT MIN(USERID) FROM USERBASE),
        'What is your favorite food?',
        'Pizza'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        7,
        (SELECT MIN(USERID) FROM USERBASE),
        'What was your childhood nickname?',
        'PlayerOne'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        8,
        (SELECT MIN(USERID) FROM USERBASE),
        'What is your favorite movie?',
        'Sample Movie'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        9,
        (SELECT MIN(USERID) FROM USERBASE),
        'What street did you grow up on?',
        'Main Street'
    )

    INTO SECURITYQUESTION
    (QUESTIONID, USERID, QUESTION, ANSWER)
    VALUES
    (
        10,
        (SELECT MIN(USERID) FROM USERBASE),
        'What was your first job?',
        'Game Store'
    )

SELECT 1 FROM DUAL;


COMMIT;



SELECT *
FROM SECURITYQUESTION
ORDER BY QUESTIONID;




CREATE TABLE COMMUNITYRULES
(
    RULENUM NUMBER(3),
    TITLE VARCHAR2(250),
    DESCRIPTION VARCHAR2(250),
    SEVERITYPOINT NUMBER(4),

    CONSTRAINT COMMUNITYRULES_PK
        PRIMARY KEY (RULENUM)
);




INSERT ALL

    INTO COMMUNITYRULES
    VALUES
    (
        1,
        'Respect',
        'Treat other users with respect.',
        100
    )

    INTO COMMUNITYRULES
    VALUES
    (
        2,
        'No Harassment',
        'Harassment or bullying of other users is prohibited.',
        500
    )

    INTO COMMUNITYRULES
    VALUES
    (
        3,
        'No Hate Speech',
        'Hateful or discriminatory language is prohibited.',
        900
    )

    INTO COMMUNITYRULES
    VALUES
    (
        4,
        'No Cheating',
        'Do not use unauthorized software or exploits.',
        700
    )

    INTO COMMUNITYRULES
    VALUES
    (
        5,
        'No Spam',
        'Do not repeatedly send unwanted messages or advertisements.',
        200
    )

    INTO COMMUNITYRULES
    VALUES
    (
        6,
        'Appropriate Content',
        'Do not post inappropriate or offensive content.',
        600
    )

    INTO COMMUNITYRULES
    VALUES
    (
        7,
        'Protect Privacy',
        'Do not share another users private information.',
        800
    )

    INTO COMMUNITYRULES
    VALUES
    (
        8,
        'No Impersonation',
        'Do not impersonate another user or staff member.',
        500
    )

    INTO COMMUNITYRULES
    VALUES
    (
        9,
        'Fair Play',
        'Play fairly and follow all game rules.',
        400
    )

    INTO COMMUNITYRULES
    VALUES
    (
        10,
        'Follow Staff Instructions',
        'Users must follow valid instructions given by platform staff.',
        750
    )

SELECT 1 FROM DUAL;




COMMIT;



SELECT *
FROM COMMUNITYRULES
ORDER BY RULENUM;





CREATE TABLE INFRACTIONS
(
    INFRACTIONID NUMBER,
    USERID NUMBER(3),
    RULENUM NUMBER(3),
    DATEASSIGNED DATE,
    PENALTY VARCHAR2(250),

    CONSTRAINT INFRACTIONS_PK
        PRIMARY KEY (INFRACTIONID),

    CONSTRAINT INFRACTIONS_USER_FK
        FOREIGN KEY (USERID)
        REFERENCES USERBASE(USERID),

    CONSTRAINT INFRACTIONS_RULE_FK
        FOREIGN KEY (RULENUM)
        REFERENCES COMMUNITYRULES(RULENUM)
);

INSERT ALL

    INTO INFRACTIONS
    VALUES
    (
        1,
        (SELECT MIN(USERID) FROM USERBASE),
        1,
        SYSDATE - 20,
        'Warning'
    )

    INTO INFRACTIONS
    VALUES
    (
        2,
        (SELECT MIN(USERID) FROM USERBASE),
        2,
        SYSDATE - 18,
        '24 hour suspension'
    )

    INTO INFRACTIONS
    VALUES
    (
        3,
        (SELECT MIN(USERID) FROM USERBASE),
        3,
        SYSDATE - 16,
        '7 day suspension'
    )

    INTO INFRACTIONS
    VALUES
    (
        4,
        (SELECT MIN(USERID) FROM USERBASE),
        4,
        SYSDATE - 14,
        '3 day suspension'
    )

    INTO INFRACTIONS
    VALUES
    (
        5,
        (SELECT MIN(USERID) FROM USERBASE),
        5,
        SYSDATE - 12,
        'Warning'
    )

    INTO INFRACTIONS
    VALUES
    (
        6,
        (SELECT MIN(USERID) FROM USERBASE),
        6,
        SYSDATE - 10,
        'Content removed'
    )

    INTO INFRACTIONS
    VALUES
    (
        7,
        (SELECT MIN(USERID) FROM USERBASE),
        7,
        SYSDATE - 8,
        'Account review'
    )

    INTO INFRACTIONS
    VALUES
    (
        8,
        (SELECT MIN(USERID) FROM USERBASE),
        8,
        SYSDATE - 6,
        '24 hour suspension'
    )

    INTO INFRACTIONS
    VALUES
    (
        9,
        (SELECT MIN(USERID) FROM USERBASE),
        9,
        SYSDATE - 4,
        'Warning'
    )

    INTO INFRACTIONS
    VALUES
    (
        10,
        (SELECT MIN(USERID) FROM USERBASE),
        10,
        SYSDATE - 2,
        '3 day suspension'
    )

SELECT 1 FROM DUAL;


COMMIT;



SELECT *
FROM INFRACTIONS
ORDER BY INFRACTIONID;





-- Question 9A
-- Kaleb Sweeney

CREATE TABLE USERSUPPORT
(
    TICKETID NUMBER,
    EMAIL VARCHAR2(250),
    ISSUE VARCHAR2(250),
    DATESUBMITTED DATE,
    DATEUPDATED DATE,
    STATUS VARCHAR2(250),

    CONSTRAINT USERSUPPORT_PK
        PRIMARY KEY (TICKETID)
);



INSERT ALL

    INTO USERSUPPORT
    VALUES
    (
        1,
        'player1@example.com',
        'Unable to log into account',
        SYSDATE - 10,
        SYSDATE - 9,
        'NEW'
    )

    INTO USERSUPPORT
    VALUES
    (
        2,
        'player2@example.com',
        'Game will not download',
        SYSDATE - 9,
        SYSDATE - 8,
        'IN PROGRESS'
    )

    INTO USERSUPPORT
    VALUES
    (
        3,
        'player3@example.com',
        'Password reset request',
        SYSDATE - 8,
        SYSDATE - 7,
        'CLOSED'
    )

    INTO USERSUPPORT
    VALUES
    (
        4,
        'player4@example.com',
        'Purchase not appearing',
        SYSDATE - 7,
        SYSDATE - 6,
        'NEW'
    )

    INTO USERSUPPORT
    VALUES
    (
        5,
        'player5@example.com',
        'Friend request problem',
        SYSDATE - 6,
        SYSDATE - 5,
        'IN PROGRESS'
    )

    INTO USERSUPPORT
    VALUES
    (
        6,
        'player6@example.com',
        'Profile image will not upload',
        SYSDATE - 5,
        SYSDATE - 4,
        'CLOSED'
    )

    INTO USERSUPPORT
    VALUES
    (
        7,
        'player7@example.com',
        'Wish list is not updating',
        SYSDATE - 4,
        SYSDATE - 3,
        'NEW'
    )

    INTO USERSUPPORT
    VALUES
    (
        8,
        'player8@example.com',
        'Chat messages missing',
        SYSDATE - 3,
        SYSDATE - 2,
        'IN PROGRESS'
    )

    INTO USERSUPPORT
    VALUES
    (
        9,
        'player9@example.com',
        'Unable to change email address',
        SYSDATE - 2,
        SYSDATE - 1,
        'NEW'
    )

    INTO USERSUPPORT
    VALUES
    (
        10,
        'player10@example.com',
        'Account settings question',
        SYSDATE - 1,
        SYSDATE,
        'CLOSED'
    )

SELECT 1 FROM DUAL;


COMMIT;



SELECT *
FROM USERSUPPORT
ORDER BY TICKETID;




CREATE OR REPLACE VIEW UNIQUE_SECURITY_QUESTIONS AS
SELECT DISTINCT QUESTION
FROM SECURITYQUESTION;



SELECT *
FROM UNIQUE_SECURITY_QUESTIONS
ORDER BY QUESTION;





CREATE OR REPLACE VIEW ACTIVE_SUPPORT_TICKETS AS
SELECT TICKETID,
       EMAIL,
       ISSUE,
       DATEUPDATED
FROM USERSUPPORT
WHERE STATUS IN ('NEW', 'IN PROGRESS')
ORDER BY DATEUPDATED ASC;



SELECT TICKETID,
       EMAIL,
       ISSUE,
       DATEUPDATED
FROM ACTIVE_SUPPORT_TICKETS
ORDER BY DATEUPDATED ASC;
