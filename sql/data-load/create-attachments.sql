do $$
declare 
  base_client character varying(32) := '23C59575B9CF467C9620760EB255B389'; -- F&B International Group
  base_org character varying(32) := 'E443A31992CB4635AFCAEABE7183CE85'; -- F&B España - Región Norte
  table_id character varying(32) := '259'; -- C_Order
  record_id character varying(32);
  attach_folder character varying(200) := '/opt/openbravo/attachments'; -- Postgres user should have write permissions for this folder
  num_attachments int := 1000;
  max_rows numeric;
begin
   raise notice 'Creating % attachments...', num_attachments;

   select c_order_id
     into record_id
     from c_order
     limit 1;

   select count(*)
     into max_rows
     from c_orderline;

   insert into c_file(
            c_file_id, ad_client_id, ad_org_id, isactive, created, createdby, 
            updated, updatedby, name, c_datatype_id, seqno, text, ad_table_id, 
            ad_record_id, path, c_attachment_conf_id)
           values (get_uuid(), '23C59575B9CF467C9620760EB255B389', 'E443A31992CB4635AFCAEABE7183CE85', 'Y', now(), '100', 
            now(), '100', 'file_'|| generate_series(1, num_attachments)||'.csv', 'text/csv', 10, null, table_id, 
            record_id, '/test', null);

   for i in 1..num_attachments loop
     raise notice '   Creating  % of %...', i, num_attachments;
     execute format('
       COPY (
         select * from c_orderline limit floor(random() * (select count(*) from c_orderline) + 1)
       )
       TO %L;', attach_folder||'/file_'||i||'.csv');
   end loop;
end$$;
