echo '#######################################################################'
echo 'local_infile: currently is'
mysql -u root -e "SHOW GLOBAL VARIABLES LIKE 'local_infile'"
echo '#######################################################################'
echo 'SET GLOBAL local_infile=1'
echo '....'
mysql -u root -e 'SET GLOBAL local_infile=1'

echo 'local_infile: currently is'
mysql -u root -e "SHOW GLOBAL VARIABLES LIKE 'local_infile'"

# see also
# https://www.basedash.com/blog/how-to-resolve-the-mysql-server-is-running-with-the-secure-file-priv-option-so-it-cannot-execute-this-statement 
# secure-file-priv
