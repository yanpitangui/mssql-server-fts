FROM mcr.microsoft.com/mssql/server:2019-CU9-ubuntu-16.04
LABEL org.opencontainers.image.source=https://github.com/yanpitangui/docker-sqlserver-fts
LABEL org.opencontainers.image.description="This repo contains the dockerfile for a sqlserver with Full Text Search pre installed"
LABEL org.opencontainers.image.licenses=MIT

USER root
RUN apt-get -y update && \
    apt-get install -yq curl apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list | tee /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update && \
    apt-get install -y mssql-server-fts && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists

USER mssql

CMD /opt/mssql/bin/sqlservr
