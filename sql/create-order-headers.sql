insert into c_order
  (c_order_id            ,ad_client_id          ,ad_org_id             ,
   createdby             ,updatedby             ,issotrx               ,
   documentno            ,docstatus             ,docaction             ,
   processed             ,c_doctype_id          ,c_doctypetarget_id    ,
   dateordered           ,dateacct              ,c_bpartner_id         ,
   c_bpartner_location_id,c_currency_id         ,paymentrule           ,
   c_paymentterm_id      ,invoicerule           ,deliveryrule          ,
   freightcostrule       ,deliveryviarule       ,priorityrule          ,
   m_warehouse_id        ,m_pricelist_id        )
select 
   get_uuid()            ,ad_client_id          ,ad_org_id             ,
   '0'                   ,'0'                   ,issotrx               ,
   documentno||'/'||s    ,docstatus             ,docaction             ,
   processed             ,c_doctype_id          ,c_doctypetarget_id    ,
   dateordered           ,dateacct              ,c_bpartner_id         ,
   c_bpartner_location_id,c_currency_id         ,paymentrule           ,
   c_paymentterm_id      ,invoicerule           ,deliveryrule          ,
   freightcostrule       ,deliveryviarule       ,priorityrule          ,
   m_warehouse_id        ,m_pricelist_id       
 from c_order c, generate_series(1, 10000) s
where c_order_id = '882E19445EF64F2F8240F17B1F75F195' ;