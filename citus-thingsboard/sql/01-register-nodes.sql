-- Jalankan di database thingsboard pada coordinator.
-- Ganti placeholder dengan IP privat masing-masing VM.
CREATE EXTENSION IF NOT EXISTS citus;
SELECT citus_set_coordinator_host('<IP-COORDINATOR>', 5433);
SELECT citus_add_node('<IP-WORKER-1>', 5433);
SELECT citus_add_node('<IP-WORKER-2>', 5433);
SELECT groupid, nodename, nodeport, noderole FROM pg_dist_node ORDER BY groupid;
