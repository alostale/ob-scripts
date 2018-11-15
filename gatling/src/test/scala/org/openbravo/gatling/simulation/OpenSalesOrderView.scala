package org.openbravo.gatling.simulation

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

import org.openbravo.gatling.base._

class OpenSalesOrderView extends Simulation {
  val scn = scenario("Open Sales Order view")
            .exec(
              OBSession.inBackoffice("Openbravo", "openbravo"),
              repeat(10) { View.open("SalesOrder") },
              OBSession.out
            )

  /*
  setUp(
  	scn.inject(rampUsers(4) over (5 seconds))
  ).protocols(Env.httpProtocol)
  */
  setUp(
  	scn.inject(atOnceUsers(1))
  ).protocols(Env.httpProtocol.disableCaching)
}