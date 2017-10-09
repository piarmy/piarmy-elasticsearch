# piarmy-elasticsearch-server

#### This is currently in progress. This notice will be removed when ready for deployment and documentation is updated. Assume unusable nonsense below.

## Notes
This is part of a tutorial series, documentation and post links coming soon.

## ON HOST, prior to deployment

#### Important: On host:
`sudo nano /etc/sysctl.conf`

Add or set:

`vm.max_map_count=262144`

# Check with:
sudo sysctl vm.max_map_count

#### Volume
In this example, we're mounting a host volume for the elasticsearch server: /data:/var/lib/elasticsearch

This /data directory *must* exist on the target host prior to deploying. This will store elasticsearch data on the host, persisting between container instances. Kibana stores it's data in elastic search, so Kibana will also persist: visualizations, dashboards, etc.


## Build and run:
```
cd /home/pi/images/piarmy-elasticsearch/server && \
  docker build -t mattwiater/piarmy-elasticsearch-server . && \
  docker run -it --rm --name piarmy-elasticsearch-server -p 9200:9200 -p 9300:9300 mattwiater/piarmy-elasticsearch-server /bin/bash
```

# Push:
```
cd /home/pi/images/piarmy-elasticsearch/server && \
  docker build -t mattwiater/piarmy-elasticsearch-server . && \
  docker push mattwiater/piarmy-elasticsearch-server
```

X-Pack (does not work for ARM)
```
cd /home/pi/images/piarmy-elasticsearch/server && \
  docker build -t mattwiater/piarmy-elasticsearch-server-xpack . && \
  docker push mattwiater/piarmy-elasticsearch-server-xpack
```

docker run -d --rm --name piarmy-elasticsearch-server-xpack -p 9222:9200 -p 9333:9300 mattwiater/piarmy-elasticsearch-server-xpack

## Service takes awhile t start, check logs with:
docker exec -it $(docker ps | grep piarmy-elasticsearch-server | awk '{print $1}') tail /var/log/elasticsearch/piarmy.log

## Enter running container
docker exec -it $(docker ps | grep piarmy-elasticsearch-server | awk '{print $1}') /bin/bash

## To get full command run by elasticsearch:

`ps auxwww`

#=>

```
/usr/bin/java -Xms256m -Xmx265m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+AlwaysPreTouch -server -Xss1m -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djna.nosys=true -Djdk.io.permissionsUseCanonicalPath=true -Dio.netty.noUnsafe=true -Dio.netty.noKeySetOptimization=true -Dio.netty.recycler.maxCapacityPerThread=0 -Dlog4j.shutdownHookEnabled=false -Dlog4j2.disable.jmx=true -Dlog4j.skipJansi=true -XX:+HeapDumpOnOutOfMemoryError -Des.path.home=/usr/share/elasticsearch -cp /usr/share/elasticsearch/lib/* org.elasticsearch.bootstrap.Elasticsearch -d -p /var/run/elasticsearch/elasticsearch.pid -Edefault.path.logs=/var/log/elasticsearch -Edefault.path.data=/var/lib/elasticsearch -Edefault.path.conf=/etc/elasticsearch

```

### X-pack
```
cd /home
wget https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-5.5.2.zip
cd /usr/share/elasticsearch
bin/elasticsearch-plugin install file:///home/x-pack-5.5.2.zip
```

### Incoming data from piarmy-collector

# {"Date":"1504616017384", "Id":"piarmy03","Name":"piarmy03","Ip":"192.168.1.112","CPU":"18.2","Temp":"115.16","RAM":{"total": "923","used": "313","free": "601"},"HDD":{"total": "30","used": "26","free": "26"}}

curl -XPUT 'elasticsearch:9200/docker_swarm_nodes' -H 'Content-Type: application/json' -d'
{
 "mappings": {
   "collision": {
     "properties": {
       "Date": {
         "type": "date"
       },
       "Ip": {
         "type": "ip"
       },
       "CPU": {
         "type": "float"
       },
       "Temp": {
         "type": "float"
       },
       "RAM.total": {
         "type": "integer"
       },
       "RAM.free": {
         "type": "integer"
       },
       "RAM.used": {
         "type": "integer"
       },
       "HDD.total": {
         "type": "float"
       },
       "HDD.free": {
         "type": "float"
       },
       "HDD.used": {
         "type": "float"
       }
     }
   }
 }
}
'