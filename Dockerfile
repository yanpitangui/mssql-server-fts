# Base OS layer: Latest Ubuntu LTS
FROM --platform=linux/amd64 phusion/baseimage:jammy-1.0.4
LABEL org.opencontainers.image.source=https://github.com/yanpitangui/mssql-server-fts
LABEL org.opencontainers.image.description="This repo contains the dockerfile for a sqlserver with Full Text Search pre installed"
LABEL org.opencontainers.image.licenses=MIT
# Install prerequistes since it is needed to get repo config for SQL server
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -yq curl apt-transport-https gnupg && \
    # Get official Microsoft repository configuration
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb --output packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | tee /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update  && \
    # Install SQL Server from apt
    apt-get install -y mssql-server && \
    # Install optional packages
    apt-get install -y mssql-server-fts && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools && \
    # Cleanup the Dockerfile
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Run SQL Server process
CMD /opt/mssql/bin/sqlservr