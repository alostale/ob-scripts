package org.openbravo.gatling.base

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

object View {
  def open(view:String) = {
  	def viewId = views (view)
    exec(
      http("Open view " + view)
        .get("/org.openbravo.client.kernel/OBUIAPP_MainLayout/View?viewId=_" + viewId)
    )
  };

  val views = Map(
    "SalesOrder"       -> "143",
    "Business Partner" -> "123",
    "Product"          -> "140",
    "Sales Invoice"    -> "167"
  );
}

