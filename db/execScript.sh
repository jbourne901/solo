#!/bin/bash


 echo "Executing $1 $dbname"
 PGPASSWORD=$dbpass psql -h $dbhost $dbname -q -U postgres -f $1


