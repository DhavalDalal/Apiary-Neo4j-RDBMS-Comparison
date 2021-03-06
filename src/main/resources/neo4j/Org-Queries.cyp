## Handy Cypher Queries
##################################################

## Count of all nodes and relationships
start n = node(*) match n-[r?]->() return count(distinct(n)), count(distinct(r));

## Delete All nodes and relationships
start n = node(*) match n-[r?]->() delete r, n;

## Delete Node 0
start n = node(0) delete n;

# People at Top Level
###################################################
start n = node(*) where n.level = 1 return id(n) as ID, n.name as Name;

# People with same names
###################################################
start n = node(*)
match n-[r?*]->m
where n.name = m.name
return distinct n.level as Level, n.name as Name
order by Level;

## Measurement Queries
##################################################
## Aggregate Data
## Count of People At all levels
start n = node(*) return n.level as Level, count(n) as Total order by Level;

## Traversal Aggregate Query - Generic Form
#################################################
start n = node:Person(name = "fName lName")
match n-[:DIRECTLY_MANAGES*0..(totalLevels - n.level)]->m-[:DIRECTLY_MANAGES*1..(totalLevels - n.level)]->o
where n.level + visibilityLevel >= m.level
return m.name as Subordinate, count(o) as Total;

# removed as a part of query optimization
# return n.name as BigBoss, m.name as Subordinate, m.level as SubordinateLevel, count(o) as Total
# order by SubordinateLevel;
################################################

## Traversal Queries returning names of people that directly or indirectly report
## to a particular person via intermediary bosses.
## Generic Query
################################################
start n = node:Person(name = "fName lName")
match p = n-[:DIRECTLY_MANAGES*1..visibilityLevel]->m
return nodes(p);

#
# After removing order by we got up to 50% improvement in query response time
# order by length(p);

## TODO:
## Hierarchy Lineage
##############################################
start n = node:Person(name = "fName lName")
match m<-[DIRECTLY_REPORTS_TO|INDIRECTLY_REPORTS_TO*]-n
return m.name as Manager, m.level as ManagerLevel, n.name, n.level
order by ManagerLevel;