name := """Neo4j Apiary Application"""

version := "0.1"

scalaVersion := "2.10.1"

javaOptions in (Test,run) += "-Xmx512M -Xms16M -Xss16M"

resolvers += "Neo4J Snapshots and Versions" at "http://m2.neo4j.org/content/groups/everything"

//resolvers += "sonatype-public" at "https://oss.sonatype.org/content/groups/public"

resolvers += "jboss" at "http://repository.jboss.org/maven2"

//console <<= (compilers in console, fullClasspath in Runtime, scalacOptions in console, initialCommands in console, streams) map {
//  (cs, cp, options, initCommands, s) =>
//     val cleanupCommands = ""
//     (new Console(cs.scalac))(Build.data(cp), options, initCommands, cleanupCommands, s.log).foreach(msg => sys.error(msg))
//     println()
//}

libraryDependencies ++= Seq(
    "org.neo4j" % "neo4j" % "1.9",
    "org.neo4j" % "neo4j-rest-graphdb" % "1.9",
    "org.specs2" % "specs2_2.10" % "2.2" % "test",
    "mysql" % "mysql-connector-java" % "5.1.9",
    "org.hibernate" % "hibernate-core" % "3.5.5-Final",
    "org.hibernate.javax.persistence" % "hibernate-jpa-2.0-api" % "1.0.1.Final",
    "org.hibernate" % "hibernate-annotations" % "3.5.5-Final",
    "org.slf4j" % "slf4j-simple" % "1.5.6",
	"javassist" % "javassist" % "3.12.1.GA"
)
