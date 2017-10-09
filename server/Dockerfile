FROM hypriot/rpi-java

RUN apt-get update && \
  apt-get -yq install nano net-tools nmap wget curl

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.2.deb && \
	dpkg -i elasticsearch-5.5.2.deb

COPY start.sh /home/start.sh
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY jvm.options /etc/elasticsearch/jvm.options

RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN rm /data/elasticsearch-5.5.2.deb

COPY containerFiles /home/testing

WORKDIR /home

# X-Pack Plugin (does not work for ARM)
# RUN cd /home && \
#   wget https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-5.5.2.zip && \
#   cd /usr/share/elasticsearch && \
#   bin/elasticsearch-plugin install --batch file:///home/x-pack-5.5.2.zip && \
#   cd /home && \
#   rm x-pack-5.5.2.zip

EXPOSE 9200 9300

CMD ["/bin/bash", "/home/start.sh"]