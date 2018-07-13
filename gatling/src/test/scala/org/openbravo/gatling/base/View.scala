package org.openbravo.gatling.base

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

object View {
  def open(viewId:String) =
    exec(
      http("Open view " + viewId)
        .get("/org.openbravo.client.kernel/OBUIAPP_MainLayout/View?viewId=_" + viewId)
    )
}

