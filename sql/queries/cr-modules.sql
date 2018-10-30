-- Published modules with number of downloads YTD

copy(
with recursive packs(pack_name, dep_mod_id) as (
   select (case obucr_module_id 
                when '0138E7A89B5E4DC3932462252801FFBC' then '00'
                when '03FAB282A7BF47D3B1B242AC67F7845B' then '10'
                when '6AE474A2704848F5BB9D09967102BE19' then '11'
                when 'B8EBD2025A384CBDA63A6F2957135F9C' then '20'
                when 'B8EBD2025A384CBDA63A6F2957135FFC' then '21' 
                else '90' end) || ' - ' || name, 
     obucr_module_id
     from obucr_module m
    where obucr_module_id in (
       '03FAB282A7BF47D3B1B242AC67F7845B',
       'B8EBD2025A384CBDA63A6F2957135F9C',
       'B8EBD2025A384CBDA63A6F2957135FFC',
       'E45ACD2DB5004D05ABFF86E7A78E056A',
       'C1825F07175E45EEAFE1F1B86C1893AA',
       'CBAC4B9ABEC1461A9C55CDC651E78ED1',
       'C8308921D352482D955C767239693AE6',
       '6AE474A2704848F5BB9D09967102BE19',
       'FF80818136C4C8CF0136C538E87A004E',
       'F0C9686D98194DDFBAB34FCB3066EF79',
       'D4A2C6157F0244F18710C5FD4732905C',
       '0138E7A89B5E4DC3932462252801FFBC')
    union
   select p.pack_name, d.dependent_module_id
     from obucr_module_dependency d,
          obucr_module_version v,
          packs p
    where d.obucr_module_version_id = v.obucr_module_version_id
      and v.obucr_module_id = p.dep_mod_id
),
 ci_ips(ip) as (
      select remote_ip
        from obucr_download
       where date_part('year', created) =  date_part('year',now())
       group by remote_ip
      having count(*)>1000
    )
	select m.obucr_module_id, m.name, m.javapackage, m.author, m.owner, support_type, 
	       (select (case when count(*) > 0 then 'N' else 'Y' end)
	         from obucr_module_version v
	         where iscommercial = 'N'
	          and v.obucr_module_id = m.obucr_module_id) as commercial,
	       total_downloads,
	       (select count(*)
	         from obucr_module_version v
	        where v.obucr_module_id = m.obucr_module_id) versions,
	       (select (case when count(*) = 0 then 'N' else 'Y' end)
	         from obucr_module_repo r, obucr_module_version v
	        where v.obucr_module_id = m.obucr_module_id
	          and r.obucr_module_version_id = v.obucr_module_version_id
	          and r.obucr_repository_id = 'A8015CB22E2F43AB991A5DFA387DD595'
	         ) ob3,
	       (select count(*) 
	          from obucr_download d, obucr_module_version v
	 	     where v.obucr_module_id = m.obucr_module_id
	 	       and d.obucr_module_version_id = v.obucr_module_version_id
	 	       and date_part('year', d.created) =  date_part('year',now())
	 	       and d.remote_ip not in (select ip from ci_ips)
	        ) year_downloads,
	        (
	          select coalesce(min(p.pack_name),'-')
	           from packs p
	          where m.obucr_module_id = p.dep_mod_id
	        ) included_in_pack
	  from obucr_module m
	 order by year_downloads desc) to '/tmp/modules.csv' with csv header