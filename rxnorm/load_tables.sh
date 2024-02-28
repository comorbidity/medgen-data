load_tables_sql="Load_scripts_mysql_rxn_unix.sql"
cp "mirror/scripts/mysql/$load_tables_sql" "mirror/rrf/$load_tables_sql"
cd mirror/rrf

echo "loading ... $load_tables_sql"

$mysql_dataset < $load_tables_sql  
