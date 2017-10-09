#!/bin/bash
timestamp() {
  date +"%T"
}

COUNT=0

while read f1
do
  COUNT=$(expr $COUNT + 1)
  echo "$(timestamp): $COUNT"
  curl -XPOST 'http://elasticsearch:9200/collision_info_v1/collision?pipeline=nyc_collisions_template' -H "Content-Type: application/json" -d "{ \"collision\": \"$f1\" }"
  echo "-----"
done < nypd_collision_data.trunc.csv