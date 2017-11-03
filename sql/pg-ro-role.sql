-- Keeps only those privileges that are read-only for every role in the instance
-- except those included in admin_roles array.

do $$
declare
  -- add here admin roles not to be modified
  admin_roles varchar[] := {
    "0", 
    "42D0EEB1C66F497A90DD526DC597E6F0" -- F&B Group Admin 
   };

  insecured_process numeric;
begin
  -- don't inherit process permission from window
  select count(*) 
    into insecured_process
    from ad_preference
   where property = 'SecuredProcess'
     and ad_user_id          is null
     and visibleat_client_id is null
     and visibleat_org_id    is null
     and visibleat_role_id   is null;

  if insecured_process = 0 then
    insert into ad_preference
      (ad_preference_id, ad_client_id, ad_org_id,
       createdby, updatedby, 
       ispropertylist, property, value)
    values
      (get_uuid(), '0', '0',
       '0', '0', 
       'Y', 'SecuredProcess', 'Y');
  end if;
  
  update ad_window_access
     set isreadwrite = 'N'
   where not (ad_role_id = any(admin_roles));

  -- note there might be processes not marked as report but being
  -- actual reports
  update ad_process_access pa
     set isactive = 'N'
   where not (ad_role_id = any(admin_roles))
     and exists (select 1
                   from ad_process p
                  where pa.ad_process_id = p.ad_process_id
                    and isjasper ='N' 
                    and isreport = 'N');
  
  update obuiapp_process_access pa
     set isactive = 'N'
   where not (ad_role_id = any(admin_roles))
     and exists (select 1
                   from obuiapp_process p
                  where pa.obuiapp_process_id = p.obuiapp_process_id
                    and uipattern != 'OBUIAPP_Report');

  -- note there might be forms used for repoting
  update ad_form_access
     set isactive = 'N'                    
   where not (ad_role_id = any(admin_roles));
end$$;
