#!/bin/bash

  echo "Executing $1 $dbname"
  PGPASSWORD=$dbpass psql -h $dbhost postgres -q -U postgres -f $1 



