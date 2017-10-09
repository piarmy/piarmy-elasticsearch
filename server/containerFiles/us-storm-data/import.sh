#!/bin/bash
timestamp() {
  date +"%T"
}

COUNT=0

while read f1
do
  COUNT=$(expr $COUNT + 1)
  echo "$(timestamp): $COUNT"
  curl -XPOST 'http://elasticsearch:9200/storm_data_v1/storm?pipeline=us_storm_data_template' -H "Content-Type: application/json" -d "{ \"storm\": \"$f1\" }" &
  echo "-----"
done < StormEvents2016.csv