-- =========================
-- Modifying Data
-- =========================

-- Question 1: Insert a new facility
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800);

-- Question 2: Insert a new facility using SELECT
INSERT INTO cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT MAX(facid) FROM cd.facilities) + 1,
       'Spa',
       20,
       30,
       100000,
       800;

-- Question 3: Update facility initial outlay
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;

-- Question 4: Update facility costs based on another row
UPDATE cd.facilities facs
SET membercost = (
        SELECT membercost * 1.1
        FROM cd.facilities
        WHERE facid = 0
    ),
    guestcost = (
        SELECT guestcost * 1.1
        FROM cd.facilities
        WHERE facid = 0
    )
WHERE facs.facid = 1;

-- Question 5: Delete all bookings
DELETE FROM cd.bookings;

-- Question 6: Delete a specific member
DELETE FROM cd.members
WHERE memid = 37;

-- =========================
-- Basics
-- =========================

-- Question 7: List facilities that charge a member fee less than 1/50th of monthly maintenance
SELECT facid,
       name,
       membercost,
       monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
  AND membercost < monthlymaintenance / 50.0;

-- Question 8: Find facilities with the word Tennis in the name
SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

-- Question 9: Retrieve facilities with ID 1 and 5
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);

-- Question 10: Find members who joined on or after September 1, 2012
SELECT memid,
       surname,
       firstname,
       joindate
FROM cd.members
WHERE joindate >= '2012-09-01';

-- Question 11: Produce a combined list of surnames and facility names
SELECT surname
FROM cd.members
UNION
SELECT name
FROM cd.facilities;

-- =========================
-- Join
-- =========================

-- Question 12: Find the start times of bookings by member David Farrell
SELECT bks.starttime
FROM cd.bookings bks
INNER JOIN cd.members mems
    ON mems.memid = bks.memid
WHERE mems.firstname = 'David'
  AND mems.surname = 'Farrell';

-- Question 13: Find start times for bookings for tennis courts on September 21, 2012
SELECT b.starttime AS start,
       f.name AS name
FROM cd.facilities f
INNER JOIN cd.bookings b
    ON f.facid = b.facid
WHERE f.name IN ('Tennis Court 1', 'Tennis Court 2')
  AND b.starttime >= '2012-09-21'
  AND b.starttime < '2012-09-22'
ORDER BY b.starttime;

-- Question 14: List all members and who recommended them
SELECT mems.firstname AS memfname,
       mems.surname AS memsname,
       recs.firstname AS recfname,
       recs.surname AS recsname
FROM cd.members mems
LEFT OUTER JOIN cd.members recs
    ON recs.memid = mems.recommendedby
ORDER BY memsname,
         memfname;

-- Question 15: Find members who have recommended another member
SELECT DISTINCT recs.firstname AS firstname,
                recs.surname AS surname
FROM cd.members mems
INNER JOIN cd.members recs
    ON recs.memid = mems.recommendedby
ORDER BY surname,
         firstname;

-- Question 16: Produce a list of members and their recommender
SELECT DISTINCT mems.firstname || ' ' || mems.surname AS member,
       (
           SELECT recs.firstname || ' ' || recs.surname
           FROM cd.members recs
           WHERE recs.memid = mems.recommendedby
       ) AS recommender
FROM cd.members mems
ORDER BY member;

-- =========================
-- Aggregation
-- =========================

-- Question 17: Count members by recommender
SELECT recommendedby,
       COUNT(*)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;

-- Question 18: Count total slots booked per facility
SELECT facid,
       SUM(slots) AS "Total Slots"
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

-- Question 19: Count total slots booked per facility in September 2012
SELECT facid,
       SUM(slots) AS "Total Slots"
FROM cd.bookings
WHERE starttime >= '2012-09-01'
  AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY SUM(slots);

-- Question 20: Count total slots booked per facility per month in 2012
SELECT facid,
       EXTRACT(MONTH FROM starttime) AS month,
       SUM(slots) AS "Total Slots"
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid,
         month
ORDER BY facid,
         month;

-- Question 21: Count the number of distinct members who made bookings
SELECT COUNT(DISTINCT memid)
FROM cd.bookings;

-- Question 22: Find the first booking after September 1, 2012 for each member
SELECT mems.surname,
       mems.firstname,
       mems.memid,
       MIN(bks.starttime) AS starttime
FROM cd.bookings bks
INNER JOIN cd.members mems
    ON mems.memid = bks.memid
WHERE starttime >= '2012-09-01'
GROUP BY mems.surname,
         mems.firstname,
         mems.memid
ORDER BY mems.memid;

-- Question 23: Count total members along with each member row
SELECT COUNT(*) OVER (),
       firstname,
       surname
FROM cd.members
ORDER BY joindate;

-- Question 24: Number each member by join date
SELECT ROW_NUMBER() OVER (ORDER BY joindate),
       firstname,
       surname
FROM cd.members
ORDER BY joindate;

-- Question 25: Find the facility with the highest total slots booked
SELECT facid,
       total
FROM (
    SELECT facid,
           SUM(slots) AS total,
           RANK() OVER (ORDER BY SUM(slots) DESC) AS rank
    FROM cd.bookings
    GROUP BY facid
) AS ranked
WHERE rank = 1;

-- =========================
-- String
-- =========================

-- Question 26: Concatenate surname and firstname
SELECT surname || ', ' || firstname AS name
FROM cd.members;

-- Question 27: Find members whose telephone numbers contain parentheses
SELECT memid,
       telephone
FROM cd.members
WHERE telephone ~ '[()]';

-- Question 28: Count members by the first letter of surname
SELECT SUBSTR(mems.surname, 1, 1) AS letter,
       COUNT(*) AS count
FROM cd.members mems
GROUP BY letter
ORDER BY letter;
