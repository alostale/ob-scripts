-- purge all data in DB keeping model

do $$
declare
  tbl record;
begin
  for tbl in  (select relname 
                    from pg_class c, pg_namespace ns
                where relkind ='r' 
                    and c.relnamespace = ns.oid
                    and ns.nspname = 'public'
                order by 1) loop
  
    raise notice '%', tbl.relname;
    execute 'alter table ' || tbl.relname || ' disable trigger all';
  end loop;

  for tbl in  (select relname 
                    from pg_class c, pg_namespace ns
                where relkind ='r' 
                    and c.relnamespace = ns.oid
                    and ns.nspname = 'public'
                order by 1) loop
  
    raise notice '%', tbl.relname;
    execute 'delete from ' || tbl.relname;
  end loop;
end$$;

-- now you can do whatever you need without data

-- enable triggers + constraints
do $$
declare
  tbl record;
begin
  for tbl in  (select relname 
                    from pg_class c, pg_namespace ns
                where relkind ='r' 
                    and c.relnamespace = ns.oid
                    and ns.nspname = 'public'
                order by 1) loop
  
    raise notice '%', tbl.relname;
    execute 'alter table ' || tbl.relname || ' enable trigger all';
  end loop;
end$$;
