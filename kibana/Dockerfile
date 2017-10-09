FROM resin/rpi-raspbian:jessie

# add our user and group first to make sure their IDs get assigned consistently
RUN groupadd -r kibana && useradd -r -m -g kibana kibana

RUN apt-get update && apt-get install -y \
        ca-certificates \
        wget \
        nano \
    --no-install-recommends

RUN cd /home && \
  wget https://artifacts.elastic.co/downloads/kibana/kibana-5.5.2-i386.deb && \
  dpkg -x kibana-5.5.2-i386.deb / && \
  rm kibana-5.5.2-i386.deb

RUN cd /home/ && \
  curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh && \
  /bin/bash /home/nodesource_setup.sh && \
  sudo apt-get install nodejs build-essential

COPY config/kibana.yml /etc/kibana/kibana.yml
COPY config/kibana /usr/share/kibana/bin/kibana
COPY config/kibana-plugin /usr/share/kibana/bin/kibana-plugin

# X-pack plugin  (does not work for ARM)
#RUN cd /home && \
#  wget https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-5.5.2.zip && \
#  cd /usr/share/kibana && \
#  bin/kibana-plugin install file:///home/x-pack-5.5.2.zip && \
#  cd /home && \
#  rm x-pack-5.5.2.zip

EXPOSE 5601

CMD ["/usr/share/kibana/bin/kibana"]