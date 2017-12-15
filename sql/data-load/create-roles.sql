with data(ad_role_id, rows) as(
  values (
    '463683CFA16C40C0A4EC8CF934114146', -- role to copy
    100                                 -- number of copies to generate
   )
)
,ins_role as (
  insert into ad_role
     (ad_role_id      ,ad_client_id    ,ad_org_id       ,
      createdby       ,name            ,updatedby       ,
      userlevel       ,ismanual        ,is_client_admin )
   select 
      get_uuid()      ,ad_client_id    ,ad_org_id       ,
      createdby       ,name||'-gen-'||s    ,updatedby       ,
      userlevel       ,ismanual        ,is_client_admin 
   from ad_role r, data d,  generate_series(1,d.rows) s
  where r.ad_role_id = d.ad_role_id
  returning ad_role_id, name
),
ins_ad_role_orgaccess as (
  insert into ad_role_orgaccess
    (ad_role_orgaccess_id,ad_role_id          ,ad_org_id           ,
     ad_client_id        ,createdby           ,updatedby           ,
     is_org_admin        )
  select
     get_uuid()          ,ins_role.ad_role_id ,ad_org_id           ,
     ad_client_id        ,createdby           ,updatedby           ,
     is_org_admin
  from ad_role_orgaccess ro, data d, ins_role
 where ro.ad_role_id = d.ad_role_id
)
select *
  from ins_role;

-- delete from ad_role where name like '%-gen-%';
