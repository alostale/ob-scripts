package org.openbravo.gatling.simulation

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

import org.openbravo.gatling.base._

class OpenSeveralViews extends Simulation {
  val scn = scenario("Open Several views")
            .exec(
              OBSession.inBackoffice("Openbravo", "openbravo"),
              repeat(5) { 
              	 exec(View.open("SalesOrder"))
                .exec(View.open("Business Partner"))
                .exec(View.open("Product"))
                .exec(View.open("Sales Invoice"))
              },
              OBSession.out
            )

  setUp(
  	//scn.inject(atOnceUsers(1))

    scn.inject(rampUsers(3) over (10 seconds))
  ).protocols(Env.httpProtocol.disableCaching)
}