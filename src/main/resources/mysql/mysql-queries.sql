#Handy query

SELECT count(*)
FROM person;

RESET QUERY CACHE;
FLUSH QUERY CACHE;

#People at a given level
SELECT level, name 
FROM person 
WHERE level = 1;


#Aggregate query

SELECT level, count(id)
FROM person
GROUP BY level;

##############################################################################							   
#For measurement purposes:
	#1. Current level is assumed to be always 1 
	#2. Total levels can vary
	#3. Visibility level will vary							   
##############################################################################
## Gather Subordinates names till a visibility level from a current level
##############################################################################

#Visibility level = 1
	SELECT manager.person_id AS Bigboss, manager.directly_manages AS Subordinate
	FROM person_direct_reportee manager
	WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1");  	

#Visibility level = 2
	SELECT manager.person_id AS Bigboss, manager.directly_manages AS Subordinate, depth1Reportees.directly_manages AS Reportee
	FROM person_direct_reportee manager
	LEFT JOIN person_direct_reportee depth1Reportees
	ON manager.directly_manages = depth1Reportees.person_id  
	WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1");  							   
							   
#Visibility level = 3
	SELECT manager.person_id AS Bigboss, manager.directly_manages AS Subordinate, depth1Reportees.directly_manages AS Reportee1,
	depth2Reportees.directly_manages AS Reportee2
	FROM person_direct_reportee manager 
    LEFT JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        LEFT JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id  
	WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1");

#Visibility level = 4
	SELECT manager.person_id AS Bigboss, manager.directly_manages AS Subordinate, depth1Reportees.directly_manages AS Reportee1,
	depth2Reportees.directly_manages AS Reportee2, depth3Reportees.directly_manages AS Reportee3
	FROM person_direct_reportee manager 
    LEFT JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        LEFT JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            LEFT JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id  
	WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1");							   
							   
#Visibility level = 5
	SELECT manager.person_id AS Bigboss, manager.directly_manages AS Subordinate, depth1Reportees.directly_manages AS Reportee1,
	depth2Reportees.directly_manages AS Reportee2, depth3Reportees.directly_manages AS Reportee3,
	depth4Reportees.directly_manages AS Reportee4
	FROM person_direct_reportee manager 
    LEFT JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        LEFT JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            LEFT JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                LEFT JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id  
	WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1");

#Visibility level = 6
	SELECT manager.person_id AS Bigboss, manager.directly_manages AS Subordinate, depth1Reportees.directly_manages AS Reportee1,
	depth2Reportees.directly_manages AS Reportee2, depth3Reportees.directly_manages AS Reportee3,
	depth4Reportees.directly_manages AS Reportee4, depth5Reportees.directly_manages AS Reportee5
	FROM person_direct_reportee manager 
    LEFT JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        LEFT JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            LEFT JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                LEFT JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    LEFT JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id  
	WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1");	

#Visibility level = 7
	SELECT manager.person_id AS Bigboss, manager.directly_manages AS Subordinate, depth1Reportees.directly_manages AS Reportee1,
	depth2Reportees.directly_manages AS Reportee2, depth3Reportees.directly_manages AS Reportee3, depth4Reportees.directly_manages AS Reportee4,
	depth5Reportees.directly_manages AS Reportee5, depth6Reportees.directly_manages AS Reportee6
	FROM person_direct_reportee manager 
    LEFT JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        LEFT JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            LEFT JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                LEFT JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    LEFT JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        LEFT JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id  
	WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1");							   
							   
##########################################################################################################
#Gather Subordinates Aggregate data from current level
##########################################################################################################

#total level=3
#current level=1

( #For level 1; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM ( 
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
	UNION
	
	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
	UNION
 
	SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
 ) AS T
)
UNION
( #For level 2; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM ( 
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
	UNION
 
	SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees						   
 ) AS T
 GROUP BY directReportees
)
UNION
( #For level 3; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 
	SELECT reportee.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
)

#total level=4
#current level=1

( #For level 1; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM ( 
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION
	
	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
	UNION
	
	SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
		
	UNION
 
	SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
 ) AS T
)
UNION
( #For level 2; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM ( 
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
	UNION
	
	SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees
	
	UNION
 
	SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees
 ) AS T
 GROUP BY directReportees
)
UNION
( #For level 3; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM ( 
	SELECT reportee.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
		
	UNION
	
	SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees						   
 ) AS T
 GROUP BY directReportees
)
UNION
( #For level 4; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 
	SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
)

#total level=5
#current level=1

( #For level 1; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM ( 
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION
	
	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION
	
	SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	
	UNION
	
	SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
		
	UNION
 
	SELECT manager.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
 ) AS T
)

UNION

( #For level 2; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM ( 
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION
	
	SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees
	
	UNION
	
	SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees
		
	UNION
 
	SELECT depth1Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees
 ) AS T
 GROUP BY directReportees
)
UNION
( #For level 3; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (
	SELECT reportee.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION
	
	SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees
	
	UNION
 
	SELECT depth2Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees
 ) AS T
 GROUP BY directReportees
)
UNION
( #For level 4; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM ( 
	SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
		
	UNION
	
	SELECT depth3Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	GROUP BY directReportees						   
 ) AS T
 GROUP BY directReportees
)
UNION
( #For level 5; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 
	SELECT depth3Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
)

#total level=6
#current level=1

(
 #For level 1; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
	FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
		
	UNION

	SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    		
	UNION
	
	SELECT manager.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
        	
    UNION                           
    
    SELECT manager.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
            
    ) AS T
)
UNION
(
 #For level 2; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
	FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
	GROUP BY directReportees
	
	UNION

	SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
		
	UNION
	
	SELECT depth1Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    	
    UNION                           
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
                           
    ) AS T
  GROUP BY directReportees                   	
)

UNION

(
 #For level 3; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT depth1Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	
	UNION

	SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
	UNION
	
	SELECT depth2Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    
  ) AS T
 GROUP BY directReportees
)

UNION

(
 #For level 4; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	
	UNION
	
	SELECT depth3Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth3Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
  ) AS T
 GROUP BY directReportees
)

UNION
#For level 5; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
(SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	
	SELECT depth3Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
        	
	UNION                           
    
	SELECT depth4Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees

  ) AS T
 GROUP BY directReportees
)
UNION
( #For level 6; inner unions = total levels - this level; max no. of joins = total level - current level - 1;  
    SELECT depth4Reportees.directly_manages AS directReportees, 0 AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
)

#total level=7
#current level=1

(
 #For level 1; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
	FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
		
	UNION

	SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    		
	UNION
	
	SELECT manager.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
        	
    UNION                           
    
    SELECT manager.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
            
	UNION
    
	SELECT manager.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
 ) AS T
)
UNION
(
 #For level 2; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
	FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
	GROUP BY directReportees
	
	UNION

	SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
		
	UNION
	
	SELECT depth1Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    	
    UNION                           
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
        
	UNION
    
	SELECT depth1Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
 ) AS T
  GROUP BY directReportees                   	
)

UNION

(
 #For level 3; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT depth1Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	
	UNION

	SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
	UNION
	
	SELECT depth2Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth2Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
 ) AS T
 GROUP BY directReportees
)

UNION

(
 #For level 4; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	
	UNION
	
	SELECT depth3Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth3Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth3Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
 ) AS T
 GROUP BY directReportees
)

UNION
#For level 5; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
(SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	
	SELECT depth3Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
        	
	UNION                           
    
	SELECT depth4Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth4Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
 ) AS T
 GROUP BY directReportees
)
UNION
( #For level 6; inner unions = total levels - this level; max no. of joins = total level - current level - 1;  
SELECT T.directReportees AS directReportees, sum(T.count) AS count
FROM (    
    SELECT depth4Reportees.directly_manages AS directReportees, 0 AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    	
	UNION
    
    SELECT depth5Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
 ) AS T
 GROUP BY directReportees
)
UNION
 ( #For level 7; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
    SELECT depth5Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
)                          


#total level=8
#current level=5

( #For level 5; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
    SELECT manager.person_id AS directReportees, 0 AS count
	FROM person_direct_reportee manager
	WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")   
    UNION
    
	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")   
    UNION                           
    
    SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")
        
    UNION
    
    SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")
    
  ) AS T
 )
UNION
(  #For level 6; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
SELECT T.directReportees AS directReportees, sum(T.count) AS count
FROM (    
    
    SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")   
    UNION
    
    SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")
    GROUP BY directReportees
    
    UNION
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")
    GROUP BY directReportees
  ) AS T
 GROUP BY directReportees
)
UNION
 ( #For level 7; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
    SELECT T.directReportees AS directReportees, sum(T.count) AS count
	FROM(
	
	SELECT reportee.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")
    GROUP BY directReportees
	
	UNION
	
	#no. of joins = total level - current level - 1, changes in SELECT clause and addition of GROUP BY clause;otherwise same as below SELECT
    SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")
    GROUP BY directReportees                           
) AS T
GROUP BY directReportees 
)                          
UNION
(   #For level 8; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 
    SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last117")
    
)

#total level=8
#current level=4

(#For level 4; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
  
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
	
	UNION
	
	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")   
    UNION                           
    
    SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
        
	UNION
    
	SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    	
	UNION
    
    SELECT manager.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
 ) AS T
)

UNION

(#For level 5; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
  
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")   
    UNION                           
    
    SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    GROUP BY directReportees
	
	UNION
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    GROUP BY directReportees
  ) AS T
 GROUP BY directReportees
)
UNION
(   #For level 6; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
SELECT T.directReportees AS directReportees, sum(T.count) AS count
FROM (    
    
    SELECT reportee.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
        
    UNION
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    GROUP BY directReportees
	
	UNION
	
	SELECT depth2Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    GROUP BY directReportees 
  ) AS T
 GROUP BY directReportees
)
UNION
 ( #For level 7; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
	SELECT T.directReportees AS directReportees, sum(T.count) AS count
	FROM(

    SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    	   
	UNION
	
	#no. of joins = total level - current level - 1, changes in SELECT clause and addition of GROUP BY clause;otherwise same as below SELECT
    SELECT depth3Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    GROUP BY directReportees                           
) AS T
GROUP BY directReportees 
)                          
UNION
(   #For level 8; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
		
 
    SELECT depth3Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last17")
    
)

#total level=8
#current level=3

(
 #For level 3; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
	
	UNION
  
	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
	
	UNION
	
	SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    
	
    UNION                           
    
    SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    
    
	UNION
    
	SELECT manager.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    
	
	UNION
    
    SELECT manager.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
  ) AS T
)

UNION

(
 #For level 4; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
  
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
	
	UNION
	
	SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth1Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees
	
	UNION
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees
  ) AS T
 GROUP BY directReportees
)

UNION
#For level 5; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
(SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	
	SELECT reportee.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
							   
	UNION                           
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth2Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees
	
	UNION
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees
  ) AS T
 GROUP BY directReportees
)
UNION
( #For level 6; inner unions = total levels - this level; max no. of joins = total level - current level - 1;  
SELECT T.directReportees AS directReportees, sum(T.count) AS count
FROM (    
    
    SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    
	UNION
    
    SELECT depth3Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees
	
	UNION
	
	SELECT depth3Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees 
  ) AS T
 GROUP BY directReportees
)
UNION
 ( #For level 7; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
	SELECT T.directReportees AS directReportees, sum(T.count) AS count
	FROM(

    SELECT depth3Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
	   
	UNION
	
	#no. of joins = total level - current level - 1, changes in SELECT clause and addition of GROUP BY clause;otherwise same as below SELECT
    SELECT depth4Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    GROUP BY directReportees                           
) AS T
GROUP BY directReportees 
)                          
UNION
(   #For level 8; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
		
 
    SELECT depth4Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last7")
    
)							   

#total level=8
#current level=2

(
 #For level 2; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
	UNION

	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
	
	UNION

	SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
	FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")	
		
	UNION
	
	SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    	
    UNION                           
    
    SELECT manager.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
			JOIN person_direct_reportee depth3Reportees
			ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
        
	UNION
    
	SELECT manager.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    
    	
	UNION
    
    SELECT manager.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    ) AS T
)

UNION

(
 #For level 3; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
	
	UNION

	SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
	FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")	
	GROUP BY directReportees
	
	UNION
	
	SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
			JOIN person_direct_reportee depth3Reportees
			ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth1Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    
    GROUP BY directReportees
	
	UNION
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
  ) AS T
 GROUP BY directReportees
)

UNION

(
 #For level 4; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
  
	SELECT reportee.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
	
	UNION
	
	SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
			JOIN person_direct_reportee depth3Reportees
			ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth2Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    
    GROUP BY directReportees
	
	UNION
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
  ) AS T
 GROUP BY directReportees
)

UNION
#For level 5; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
(SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	
	SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    	
	UNION                           
    
	SELECT depth3Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
			JOIN person_direct_reportee depth3Reportees
			ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth3Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    
    GROUP BY directReportees
	
	UNION
    
    SELECT depth3Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
  ) AS T
 GROUP BY directReportees
)
UNION
( #For level 6; inner unions = total levels - this level; max no. of joins = total level - current level - 1;  
SELECT T.directReportees AS directReportees, sum(T.count) AS count
FROM (    
    
    SELECT depth3Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
			JOIN person_direct_reportee depth3Reportees
			ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    
	UNION
    
    SELECT depth4Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    
    GROUP BY directReportees
	
	UNION
	
	SELECT depth4Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees                   
  ) AS T
 GROUP BY directReportees
)
UNION
 ( #For level 7; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
	SELECT T.directReportees AS directReportees, sum(T.count) AS count
	FROM(

    SELECT depth4Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
     
	UNION
	
	#no. of joins = total level - current level - 1, changes in SELECT clause and addition of GROUP BY clause;otherwise same as below SELECT
    SELECT depth5Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees                  
) AS T
GROUP BY directReportees 
)                          
UNION
(   #For level 8; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
		
 
    SELECT depth5Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last2")
    GROUP BY directReportees
    
)							   


#total level=8
#current level=1

(
 #For level 1; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.person_id AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT manager.person_id AS directReportees, count(manager.directly_manages) AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT manager.person_id AS directReportees, count(reportee.directly_manages) AS count
	FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
		
	UNION

	SELECT manager.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    		
	UNION
	
	SELECT manager.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
        	
    UNION                           
    
    SELECT manager.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
            
	UNION
    
	SELECT manager.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    	
	UNION
    
    SELECT manager.person_id AS directReportees, count(depth6Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    ) AS T
)
UNION
(
 #For level 2; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT manager.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	UNION

	SELECT reportee.person_id AS directReportees, count(reportee.directly_manages) AS count
	FROM person_direct_reportee manager
    JOIN person_direct_reportee reportee
    ON manager.directly_manages = reportee.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")	
	GROUP BY directReportees
	
	UNION

	SELECT depth1Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
		
	UNION
	
	SELECT depth1Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    	
    UNION                           
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
        
	UNION
    
	SELECT depth1Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    	
	UNION
    
    SELECT depth1Reportees.person_id AS directReportees, count(depth6Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees                   
    ) AS T
  GROUP BY directReportees                   	
)

UNION

(
 #For level 3; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT depth1Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	
	UNION

	SELECT depth2Reportees.person_id AS directReportees, count(depth2Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
	UNION
	
	SELECT depth2Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth2Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
	UNION
    
    SELECT depth2Reportees.person_id AS directReportees, count(depth6Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees                   
  ) AS T
 GROUP BY directReportees
)

UNION

(
 #For level 4; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
 SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	SELECT depth2Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
	
	UNION
	
	SELECT depth3Reportees.person_id AS directReportees, count(depth3Reportees.directly_manages) AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
    UNION                           
    
    SELECT depth3Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth3Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
	UNION
    
    SELECT depth3Reportees.person_id AS directReportees, count(depth6Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees                   
  ) AS T
 GROUP BY directReportees
)

UNION
#For level 5; inner unions = total levels - this level; max no. of joins = total level - current level - 1; 
(SELECT T.directReportees AS directReportees, sum(T.count) AS count
 FROM (    
	
	SELECT depth3Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
        	
	UNION                           
    
	SELECT depth4Reportees.person_id AS directReportees, count(depth4Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    
	UNION
    
	SELECT depth4Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
	UNION
    
    SELECT depth4Reportees.person_id AS directReportees, count(depth6Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees                   
  ) AS T
 GROUP BY directReportees
)
UNION
( #For level 6; inner unions = total levels - this level; max no. of joins = total level - current level - 1;  
SELECT T.directReportees AS directReportees, sum(T.count) AS count
FROM (    
    SELECT depth4Reportees.directly_manages AS directReportees, 0 AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    	
	UNION
    
    SELECT depth5Reportees.person_id AS directReportees, count(depth5Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
	
	UNION
	
	SELECT depth5Reportees.person_id AS directReportees, count(depth6Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees                   
  ) AS T
 GROUP BY directReportees
)
UNION
 ( #For level 7; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
	SELECT T.directReportees AS directReportees, sum(T.count) AS count
	FROM(

    SELECT depth5Reportees.directly_manages AS directReportees, 0 AS count
    FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
     
	UNION
	
	#no. of joins = total level - current level - 1, changes in SELECT clause and addition of GROUP BY clause;otherwise same as below SELECT
    SELECT depth6Reportees.person_id AS directReportees, count(depth6Reportees.directly_manages) AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
) AS T
GROUP BY directReportees 
)                          
UNION
(   #For level 8; inner unions = total levels - this level; max no. of joins = total level - current level - 1;
		
 
    SELECT depth6Reportees.directly_manages AS directReportees, 0 AS count
	FROM person_direct_reportee manager 
    JOIN person_direct_reportee depth1Reportees
    ON manager.directly_manages = depth1Reportees.person_id
        JOIN person_direct_reportee depth2Reportees
        ON depth1Reportees.directly_manages = depth2Reportees.person_id
            JOIN person_direct_reportee depth3Reportees
            ON depth2Reportees.directly_manages = depth3Reportees.person_id
                JOIN person_direct_reportee depth4Reportees
                ON depth3Reportees.directly_manages = depth4Reportees.person_id
                    JOIN person_direct_reportee depth5Reportees
                    ON depth4Reportees.directly_manages = depth5Reportees.person_id
                        JOIN person_direct_reportee depth6Reportees
                        ON depth5Reportees.directly_manages = depth6Reportees.person_id
    WHERE manager.person_id = (SELECT id
                               FROM person
                               WHERE name = "first1 last1")
    GROUP BY directReportees
    
)							   
