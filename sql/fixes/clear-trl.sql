do $$
declare 
  t record;
  base_table text;
  pk text;
  qry text;
  cnt numeric;
begin
  for t in (select tablename from ad_table where tablename ilike '%trl' and tablename not ilike 'obpos_paymethod_type_trl') loop
    base_table := substring(t.tablename from 1 for length(t.tablename) - 4);
    
    pk := base_table || '_id';

    qry := 'delete from ' || t.tablename  || ' t '
        || ' where not exists (select 1 from '|| base_table || ' b where t.'|| pk || ' =  b.'|| pk ||')';
    
    execute qry;

    get diagnostics cnt = row_count;    

    raise notice '% %', t.tablename, cnt;
  end loop;

  for t in (select tablename from ad_table where tablename ilike '%\_access' and tablename not in ('OBPOS_Userterminal_Access', 'MAGCON_Magento_Access', 'OBUIAPP_NAVBAR_ROLE_ACCESS', 'obuiapp_view_role_access')) loop
    base_table := substring(t.tablename from 1 for length(t.tablename) - 7);
    
    pk := base_table || '_id';

    qry := 'delete from ' || t.tablename  || ' t '
        || ' where not exists (select 1 from '|| base_table || ' b where t.'|| pk || ' =  b.'|| pk ||')';
    
    execute qry;

    get diagnostics cnt = row_count;    

    raise notice '% %', t.tablename, cnt;
  end loop;

  delete from ad_process_request r
   where not exists (select 1 from ad_process p where r.ad_process_id = p.ad_process_id);

  get diagnostics cnt = row_count;    

  raise notice 'ad_process_request %', cnt;
end $$;
