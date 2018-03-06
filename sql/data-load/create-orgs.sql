do $$
declare 
  base_org character varying(32) := 'B5DE96143D6642228E3B9DEC69886A47'; -- Possets
  max_orgs numeric := 600;
  deep_tree character(1) := 'N';

  new_org_id character varying(32);
  parent character varying(32);
begin
   raise notice 'Creating % organizations...', max_orgs;

   select parent_id
     into parent
     from ad_treenode
    where node_id = base_org;

   for i in 1..max_orgs loop
     raise notice '   Creating  % of %...', i, max_orgs;
     new_org_id := get_uuid();
     
     insert into ad_org
            (ad_org_id, ad_client_id, createdby, updatedby,
            value, name, ad_orgtype_id, isperiodcontrolallowed,
            isready, c_currency_id, em_obretco_retailorgtype,
            em_obretco_pricelist_id,  em_obretco_productlist_id, em_obretco_c_bpartner_id , em_obretco_c_bp_location_id,
            em_obretco_m_warehouse_id, em_obretco_dbp_irulesid  , em_obretco_dbp_ptermid   ,
            em_obretco_dbp_pmethodid , em_obretco_dbp_bpcatid   , em_obretco_dbp_countryid ,
            em_obretco_dbp_orgid     , em_obretco_showtaxid     , em_obretco_showbpcategory,
            issummary
            )
     select new_org_id, ad_client_id, '0', '0',
            'gen-'||i, 'gen-'||i, ad_orgtype_id, isperiodcontrolallowed,
             'N', c_currency_id, em_obretco_retailorgtype,
            em_obretco_pricelist_id,  em_obretco_productlist_id, em_obretco_c_bpartner_id , em_obretco_c_bp_location_id,
            em_obretco_m_warehouse_id, em_obretco_dbp_irulesid  , em_obretco_dbp_ptermid   ,
            em_obretco_dbp_pmethodid , em_obretco_dbp_bpcatid   , em_obretco_dbp_countryid ,
            em_obretco_dbp_orgid     , em_obretco_showtaxid     , em_obretco_showbpcategory,
            deep_tree
      from ad_org
       where ad_org_id = base_org;

      update ad_treenode
        set parent_id = parent
        where node_id = new_org_id;

      update ad_org 
        set isready='Y'
      where ad_org_id = new_org_id;

      if deep_tree = 'Y' then
        parent := new_org_id;
      end if;
   end loop;
end$$;

-- delete from ad_treenode where ad_org_id in (select ad_org_id from ad_org where name like 'gen-%');
-- delete from ad_preference where visibleat_org_id in (select ad_org_id from ad_org where name like 'gen-%');
-- delete from ad_org where name like 'gen-%';
