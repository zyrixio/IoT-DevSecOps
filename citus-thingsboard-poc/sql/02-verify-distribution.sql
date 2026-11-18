-- Tipe tiap tabel
SELECT table_name, citus_table_type, distribution_column
FROM citus_tables ORDER BY citus_table_type, table_name;

-- Jumlah shard per tabel distributed
SELECT table_name, count(DISTINCT shardid) AS jumlah_shard
FROM citus_shards WHERE citus_table_type = 'distributed'
GROUP BY table_name ORDER BY table_name;

-- Sebaran shard per node
SELECT nodename, count(*) AS shards FROM citus_shards GROUP BY nodename;

-- Posisi device per worker
SELECT d.name, s.nodename
FROM device d
JOIN citus_shards s
  ON s.shardid = get_shard_id_for_distribution_column('device', d.id)
ORDER BY s.nodename, d.name;
