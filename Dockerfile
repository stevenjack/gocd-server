FROM java:7
MAINTAINER Steven Jack, stevenmajack@gmail.com

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y curl unzip git subversion mercurial

ADD ssh_config /etc/ssh/ssh_config

RUN curl -L -o /tmp/go-server.deb http://download.go.cd/gocd-deb/go-server-14.2.0-377.deb 
RUN dpkg -i /tmp/go-server.deb
RUN rm /tmp/go-server.deb

RUN sed -r -i "s/^(DAEMON)=(.*)/\1=\N/g" /etc/default/go-server

EXPOSE 8153
EXPOSE 8154

RUN mkdir -p /var/lib/go-server/db/h2db
ADD backup/db/cruise.h2.db /var/lib/go-server/db/h2db/cruise.h2.db

ADD backup/config-dir/ /etc/go/

RUN mkdir -p /var/lib/go-server/db/config.git
ADD backup/config-repo/ /var/lib/go-server/db/config.git

CMD /usr/share/go-server/server.sh
