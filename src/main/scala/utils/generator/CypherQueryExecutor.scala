package utils.generator

import scala.Predef._
import utils.NeoDB

trait CypherQueryExecutor {
  def execute(cql: String, params: Map[String, Any] = Map())(implicit neo4j: NeoDB) = {
    info("Executing Parameteric Cypher query %s\n", cql)
    val startTime = System.currentTimeMillis
    val result = neo4j.execute(cql, params)
    val executionTime = System.currentTimeMillis - startTime
//    info("Execution result:\n%s\n", result.dumpToString)
    info("Execution Took %d (ms)\n", executionTime)
    (result, executionTime)
  }
}
