### piarmy-elasticsearch: Notes

```
cd /home/pi/images/piarmy-elasticsearch/kibana && \
  docker build -t mattwiater/piarmy-elasticsearch-kibana . && \
  docker push mattwiater/piarmy-elasticsearch-kibana
```

```
cd /home/pi/images/piarmy-elasticsearch/client && \
  docker build -t mattwiater/piarmy-elasticsearch-client . && \
  docker push mattwiater/piarmy-elasticsearch-client
```

```
cd /home/pi/images/piarmy-elasticsearch/server && \
  docker build -t mattwiater/piarmy-elasticsearch-server . && \
  docker push mattwiater/piarmy-elasticsearch-server
```

```
cd /home/pi/images/piarmy-elasticsearch && \
  docker stack deploy -c piarmy-elasticsearch.yml elasticsearch
```

`docker service ls` #=>

```

```

### Start logstash import:
(sudo nc localhost 5000 < /var/log/daemon.log &) > /dev/null 2>&1

### Access:
`http://piarmy01:5601/`

`http://piarmy01:5601/app/sense`

Must use IP address in query:
`docker node inspect self --format '{{ .Status.Addr  }}'` => 10.1.8.26

In server field, use: `http://10.1.8.26:9200`


### Misc

#### Cluster Health
`curl -XGET "http://piarmy01:9200/_cluster/health"`

#### Elasticsearch API

List indexes: `http://10.1.8.26:9200/_cat/indices?v` #=>

Filter by index:
`http://4ab9f6c4.ngrok.io/_search?index=blog`

Mappings:
http://4ab9f6c4.ngrok.io/_mappings

Posts Search:
http://4ab9f6c4.ngrok.io/blog/post/_search

Tag search:
http://piarmy04:9200/blog/_search?q=post_tag:raspberry-pi

Text Search:
http://piarmy04:9200/blog/_search?q=post_content:benchmark

### Console: http://piarmy04:5601/app/kibana#/dev_tools/console

Filtering:
GET blog/_search
{
  "query": {
    "bool": {
      "filter": [
        { "term": { "category": "overview"}}
      ]
    }
  }
}

# Basic Match
GET blog/_search
{
"query" : {
        "match": { "post_content": "twelve" }
    }
}

# Multi-match:
GET blog/_search
{
"query" : {
        "multi_match" : {
          "query":    "minio", 
          "fields": [ "post_content", "post_tag" ] 
        }
    }
}


# Highlight
GET blog/_search
{
"query" : {
        "multi_match" : {
          "query":    "minio", 
          "fields": [ "post_content", "post_tag" ] 
        }
    },
    "highlight" : {
        "fields" : {
            "post_content" : {},
            "post_tag" : {}
        }
    }
}

```
health status index               pri rep docs.count docs.deleted store.size pri.store.size 
yellow open   .kibana               1   1          2            1     10.6kb         10.6kb 
yellow open   logstash-2017.08.18   5   1         10            0     20.3kb         20.3kb 
```

Get index: `http://10.1.8.26:9200/logstash-2017.08.18`