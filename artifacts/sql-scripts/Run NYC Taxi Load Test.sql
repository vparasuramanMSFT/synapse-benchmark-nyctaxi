EXECUTE sp_create_users

EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_rr_heap_parquet','ROUND_ROBIN','HEAP'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_rr_cci_parquet','ROUND_ROBIN','CLUSTERED COLUMNSTORE INDEX'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_hash_heap_parquet','HASH(hashCol)','HEAP'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_hash_cci_parquet','HASH(hashCol)','CLUSTERED COLUMNSTORE INDEX'

EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_rr_heap_csv_gzip','ROUND_ROBIN','HEAP'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_rr_cci_csv_gzip','ROUND_ROBIN','CLUSTERED COLUMNSTORE INDEX'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_hash_heap_csv_gzip','HASH(hashCol)','HEAP'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_hash_cci_csv_gzip','HASH(hashCol)','CLUSTERED COLUMNSTORE INDEX'

EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_rr_heap_csv','ROUND_ROBIN','HEAP'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_rr_cci_csv','ROUND_ROBIN','CLUSTERED COLUMNSTORE INDEX'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_hash_heap_csv','HASH(hashCol)','HEAP'
EXECUTE sp_create_table_nyctaxi 'nyctaxi_src_hash_cci_csv','HASH(hashCol)','CLUSTERED COLUMNSTORE INDEX'

EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_rr_heap_parquet','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-parquet/','Parquet','Snappy'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_rr_cci_parquet','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-parquet/','Parquet','Snappy'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_hash_heap_parquet','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-parquet/','Parquet','Snappy'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_hash_cci_parquet','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-parquet/','Parquet','Snappy'

EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_rr_heap_csv_gzip','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-csv-gzip/','CSV','Gzip'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_rr_cci_csv_gzip','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-csv-gzip/','CSV','Gzip'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_hash_heap_csv_gzip','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-csv-gzip/','CSV','Gzip'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_hash_cci_csv_gzip','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-csv-gzip/','CSV','Gzip'

EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_rr_heap_csv','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-csv/','CSV','NONE'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_rr_cci_csv','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-csv/','CSV','NONE'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_hash_heap_csv','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-csv/','CSV','NONE'
EXECUTE sp_copy_into_nyctaxi 'smallrc_user','nyctaxi_src_hash_cci_csv','https://your-storage-account.dfs.core.windows.net/your-container/nyctlc-nopartition-csv/','CSV','NONE'

EXECUTE sp_ctas_nyctaxi 'largerc_user','nyctaxi_lrc_hash_cci_from_rr_heap','nyctaxi_src_rr_heap_parquet','HASH(hashCol)','CLUSTERED COLUMNSTORE INDEX'
EXECUTE sp_ctas_nyctaxi 'largerc_user','nyctaxi_lrc_hash_cci_from_hash_heap','nyctaxi_src_hash_heap_parquet','HASH(hashCol)','CLUSTERED COLUMNSTORE INDEX'