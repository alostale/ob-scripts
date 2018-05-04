with data (rows, days, status) as (
  values (
     1000000,             -- number of rows to create
     30,             -- starting n days ago
     '{S, F}'::text[]
  )
), 
users as (
  select array_agg(username) u 
    from ad_user 
   where username is not null
),
generate_logins as (
  select u.u[floor(random()*array_length(u.u,1)+1)] username, 
         d.status[floor(random()*array_length(d.status,1)+1)] login_status,
         now() - ((d.days || ' day')::interval / d.rows) * s as creation_time
    from data d,  
         generate_series(1,d.rows) s,
         users u
),
insert_sessions as (
  insert into ad_session
      (ad_session_id  , ad_client_id   , ad_org_id      , 
       created        , createdby      , updated        , 
       updatedby      , username       , login_status   )
  select get_uuid(), '0', '0',
         l.creation_time, '0', l.creation_time,
         '0', l.username, l.login_status
    from generate_logins l
  returning ad_session_id, created, username, login_status
)
select * from insert_sessions;

