FROM resin/rpi-raspbian:latest
#FROM hypriot/rpi-java

RUN apt-get update && apt-get -y upgrade && \
  apt-get -yq install nano net-tools nmap wget curl oracle-java8-jdk && \
  apt-get -y autoremove && apt-get -y autoclean

#RUN apt-get -yq install software-properties-common && \
#  add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" && \
#  apt-get update && \
#  apt-get install oracle-java8-installer && \
#  apt-get update && apt-get -y upgrade && \
#  apt-get autoremove && apt-get autoclean

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.2.deb && \
  dpkg -i elasticsearch-5.5.2.deb

COPY start.sh /home/start.sh
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY jvm.options /etc/elasticsearch/jvm.options

#RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

#RUN rm /data/elasticsearch-5.5.2.deb

COPY containerFiles /home/testing

WORKDIR /home

EXPOSE 9200 9300

CMD ["/bin/bash", "/home/start.sh"]