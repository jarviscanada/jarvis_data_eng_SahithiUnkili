# Introduction
This module contains SQL queries for data analysis and reporting.

# SQL Queries

## Table Setup (DDL)

CREATE TABLE cd.members
    (
       memid integer NOT NULL, 
       surname character varying(200) NOT NULL, 
       firstname character varying(200) NOT NULL, 
       address character varying(300) NOT NULL, 
       zipcode integer NOT NULL, 
       telephone character varying(20) NOT NULL, 
       recommendedby integer,
       joindate timestamp NOT NULL,
       CONSTRAINT members_pk PRIMARY KEY (memid),
       CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
            REFERENCES cd.members(memid) ON DELETE SET NULL
    );

CREATE TABLE cd.facilities
    (
       facid integer NOT NULL, 
       name character varying(100) NOT NULL, 
       membercost numeric NOT NULL, 
       guestcost numeric NOT NULL, 
       initialoutlay numeric NOT NULL, 
       monthlymaintenance numeric NOT NULL, 
       CONSTRAINT facilities_pk PRIMARY KEY (facid)
    );
        

  CREATE TABLE cd.bookings
    (
       bookid integer NOT NULL, 
       facid integer NOT NULL, 
       memid integer NOT NULL, 
       starttime timestamp NOT NULL,
       slots integer NOT NULL,
       CONSTRAINT bookings_pk PRIMARY KEY (bookid),
       CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
       CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
    );
         
## Modifying Data

###Question 1: Insert a new facility
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800);

###Question 2: Insert using SELECT
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT MAX(facid) FROM cd.facilities)+1,
       'Spa', 20, 30, 100000, 800;

###Question 3: Update facility
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;

###Question 4: Update with calculation
UPDATE cd.facilities facs
SET membercost = (
    SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0
),
guestcost = (
    SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0
)
WHERE facs.facid = 1;

###Question 5: Delete all bookings
DELETE FROM cd.bookings;

###Question 6: Delete specific member
DELETE FROM cd.members
WHERE memid = 37;
Basics

###Question 7
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
AND membercost < monthlymaintenance/50.0;

###Question 8
SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

###Question 9
SELECT *
FROM cd.facilities
WHERE facid IN (1,5);

###Question 10
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';

###Question 11 (UNION)
SELECT surname FROM cd.members
UNION
SELECT name FROM cd.facilities;
Join Queries

###Question 12
SELECT bks.starttime
FROM cd.bookings bks
JOIN cd.members mems
ON mems.memid = bks.memid
WHERE mems.firstname='David'
AND mems.surname='Farrell';

###Question 13
SELECT b.starttime, f.name
FROM cd.facilities f
JOIN cd.bookings b ON f.facid = b.facid
WHERE f.name IN ('Tennis Court 1','Tennis Court 2')
AND b.starttime >= '2012-09-21'
AND b.starttime < '2012-09-22'
ORDER BY b.starttime;

###Question 14
SELECT mems.firstname, mems.surname,
       recs.firstname, recs.surname
FROM cd.members mems
LEFT JOIN cd.members recs
ON recs.memid = mems.recommendedby
ORDER BY mems.surname, mems.firstname;

###Question 15
SELECT DISTINCT recs.firstname, recs.surname
FROM cd.members mems
JOIN cd.members recs
ON recs.memid = mems.recommendedby
ORDER BY recs.surname, recs.firstname;

###Question 16
SELECT mems.firstname || ' ' || mems.surname AS member,
(
SELECT recs.firstname || ' ' || recs.surname
FROM cd.members recs
WHERE recs.memid = mems.recommendedby
) AS recommender
FROM cd.members mems
ORDER BY member;

##Aggregation

###Question 17
SELECT recommendedby, COUNT(*)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;

###Question 18
SELECT facid, SUM(slots)
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

###Question 19
SELECT facid, SUM(slots)
FROM cd.bookings
WHERE starttime >= '2012-09-01'
AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY SUM(slots);

###Question 20
SELECT facid,
EXTRACT(MONTH FROM starttime),
SUM(slots)
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime)=2012
GROUP BY facid, EXTRACT(MONTH FROM starttime)
ORDER BY facid;

###Question 21
SELECT COUNT(DISTINCT memid)
FROM cd.bookings;

###Question 22
SELECT mems.surname, mems.firstname, mems.memid,
MIN(bks.starttime)
FROM cd.bookings bks
JOIN cd.members mems
ON mems.memid = bks.memid
WHERE starttime >= '2012-09-01'
GROUP BY mems.surname, mems.firstname, mems.memid
ORDER BY mems.memid;

###Question 23
SELECT COUNT(*) OVER(), firstname, surname
FROM cd.members
ORDER BY joindate;

###Question 24
SELECT ROW_NUMBER() OVER(ORDER BY joindate),
firstname, surname
FROM cd.members;

###Question 25
SELECT facid, total
FROM (
SELECT facid, SUM(slots) total,
RANK() OVER (ORDER BY SUM(slots) DESC) rank
FROM cd.bookings
GROUP BY facid
) ranked
WHERE rank = 1;
String Queries

###Question 26
SELECT surname || ', ' || firstname
FROM cd.members;

###Question 27
SELECT memid, telephone
FROM cd.members
WHERE telephone ~ '[()]';

###Question 28
SELECT SUBSTR(surname,1,1), COUNT(*)
FROM cd.members
GROUP BY SUBSTR(surname,1,1)
ORDER BY 1;

##Key Learnings
SQL CRUD operations
Filtering and conditions
Joins and relational logic
Aggregation and grouping
Window functions
String manipulation
