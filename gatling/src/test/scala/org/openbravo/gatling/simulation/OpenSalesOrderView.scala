package org.openbravo.gatling.simulation

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

import org.openbravo.gatling.base._

class OpenSalesOrderView extends Simulation {
  val httpProtocol = http.baseURL("http://localhost:8484/openbravo")

  val scn = scenario("Open Sales Order view")
            .exec(
           	  Log.inBackoffice("Openbravo", "openbravo"),
           	  repeat(5) { View.open("143") },
           	  Log.out
           	)

  setUp(
  	scn.inject(rampUsers(4) over (5 seconds))
  ).protocols(httpProtocol)
}