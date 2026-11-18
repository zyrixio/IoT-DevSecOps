# PoC ThingsBoard di atas Citus

ThingsBoard CE 4.4.0.1 dengan database PostgreSQL terdistribusi (Citus).
Versi yang diuji: PostgreSQL 18.4, Citus 14.2.0.

## Topologi
| Peran | Folder |
|---|---|
| Coordinator + ThingsBoard | `coordinator/`, `thingsboard/` |
| Worker 1 dan 2 | `worker/` |

## Urutan menjalankan
1. Di tiap VM, salin `.env.example` menjadi `.env` lalu isi nilainya (password harus sama di semua node).
2. Worker (kedua VM): `cd worker && docker compose up -d`
3. Coordinator: `cd coordinator && docker compose up -d`
4. Daftarkan node: ganti placeholder IP di `sql/01-register-nodes.sql`, lalu jalankan di database `thingsboard` pada coordinator.
5. ThingsBoard: install schema dengan Citus aktif, lalu jalankan:
   ```
   cd thingsboard
   docker compose run --rm -e INSTALL_TB=true -e LOAD_DEMO=true thingsboard-ce
   docker compose up -d
   ```
   Di log install harus muncul `Citus enabled: distributing KV tables...`.
6. Verifikasi: jalankan `sql/02-verify-distribution.sql` di coordinator.

## Catatan
- Port host 5433 dipakai karena salah satu VM sudah memakai 5432 untuk layanan lain.
- `CITUS_SHARD_COUNT` terkunci setelah tabel didistribusikan; mengubahnya butuh install ulang.
- `ts_kv` (riwayat time-series) tidak didistribusikan oleh ThingsBoard.
- Jangan commit file `.env`. Gunakan `.env.example` sebagai template.
- Untuk hasil yang bisa diulang, catat digest image: `docker inspect --format '{{index .RepoDigests 0}}' citusdata/citus:latest`.
