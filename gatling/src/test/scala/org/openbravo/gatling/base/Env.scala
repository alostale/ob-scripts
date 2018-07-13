package org.openbravo.gatling.base

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

object Env {
	val httpProtocol = http.baseURL("http://localhost:8484/openbravo")
}