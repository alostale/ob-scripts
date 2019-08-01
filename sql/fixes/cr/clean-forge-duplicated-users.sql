do $$
declare
  u record;
  p record;
  kept_usr record;
  cnt integer;
  kept_permission_id character varying;
begin
  raise notice '%', 'Deleting duplicated users...';
  for u in (select username, count(*) cnt
              from obforge_user 
             group by 1 having count(*)>1 order by 2 desc) loop
    raise notice 'u: %, cnt: %', u.username, u.cnt;

    select obforge_user_id, created
      into kept_usr
      from obforge_user
     where username = u.username
     order by created
     limit 1;

     update obforge_project_permission
        set obforge_user_id = kept_usr.obforge_user_id
      where obforge_user_id in (select obforge_user_id
                                  from obforge_user
                                 where username = u.username
                                   and obforge_user_id != kept_usr.obforge_user_id);
     get diagnostics cnt = row_count;
     raise notice '   updated % projects', cnt;

     delete from obforge_user
      where obforge_user_id in (select obforge_user_id
                                  from obforge_user
                                 where username = u.username
                                   and obforge_user_id != kept_usr.obforge_user_id);
     get diagnostics cnt = row_count;
     raise notice '   deleted % users', cnt;
  end loop;

  raise notice '%', 'Deleting duplicated permissions...';
  for p in (select count(*), obforge_user_id, obforge_project_id, role 
              from obforge_project_permission 
             group by 2,3,4 having count(*) > 1 order by 1 desc) loop
    select obforge_project_permission_id
      into kept_permission_id
      from obforge_project_permission
     where obforge_user_id = p.obforge_user_id
       and obforge_project_id = p.obforge_project_id
       and role = p.role
     order by created
     limit 1;

    delete from obforge_project_permission
     where obforge_user_id = p.obforge_user_id
       and obforge_project_id = p.obforge_project_id
       and role = p.role
       and obforge_project_permission_id != kept_permission_id;
     get diagnostics cnt = row_count;
     raise notice '   deleted % permissions for project %', cnt, p.obforge_project_id;
  end loop;
end$$;
