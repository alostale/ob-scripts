do $$
declare 
  r record;
  t record;
  query text;
  params text;
  type text;
begin
  for r in (select proname, proargtypes 
              from pg_proc p, pg_namespace n 
             where n.nspname = current_schema() 
               and p.pronamespace = n.oid 
               and p.oid not in (select tgfoid from pg_trigger)
               and proname not like 'pg_%' 
               and proname not like 'uuid_%' 
               and proname not in ( 'get_uuid',
                                    'hex_to_int',
                                    'gin_extract_query_trgm',
                                    'gin_extract_value_trgm',
                                    'gin_trgm_consistent',
                                    'gin_trgm_triconsistent',
                                    'gtrgm_compress',
                                    'gtrgm_consistent',
                                    'gtrgm_decompress',
                                    'gtrgm_distance',
                                    'gtrgm_in',
                                    'gtrgm_out',
                                    'gtrgm_penalty',
                                    'gtrgm_picksplit',
                                    'gtrgm_same',
                                    'gtrgm_union',
                                    'set_limit',
                                    'show_limit',
                                    'show_trgm',
                                    'similarity',
                                    'similarity_dist',
                                    'similarity_op',
                                    'word_similarity',
                                    'word_similarity_dist_op',
                                    'word_similarity_dist_commutator_op',
                                    'word_similarity_op',
                                    'word_similarity_commutator_op')
                order by 1
             ) loop
    params := '';

    -- this loop is needed to gurantee correct sorting
    for t in (select unnest(r.proargtypes) as toid) loop
      select pt.typname 
        into type
        from pg_type pt 
       where pt.oid = t.toid;

      if params != '' then
        params := params || ', ';
      end if;

      params := params || type; 
    end loop;

    params := '(' || params || ')';
    query = 'alter function ' || r.proname || params || ' set search_path = ' || current_schema();
    raise notice '% ', query || ';';

    execute query;
  end loop;
end $$;