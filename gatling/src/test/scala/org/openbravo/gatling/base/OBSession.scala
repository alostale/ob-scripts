package org.openbravo.gatling.base

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

object Log {
  def inBackoffice(user: String, password:String) =
  	exec(
      http("log in")
        .post("/secureApp/LoginHandler.html")
        .formParam("user", user)
        .formParam("password", password)
    )

  val out = exec(
        http("log out")
        .post("/org.openbravo.client.kernel?_action=org.openbravo.client.application.LogOutActionHandler")
    )
}

