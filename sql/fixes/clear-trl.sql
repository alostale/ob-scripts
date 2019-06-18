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
end $$;
