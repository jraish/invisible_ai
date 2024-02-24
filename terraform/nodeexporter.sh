useradd -M -r -s /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar xzf node_exporter-1.6.1.linux-amd64.tar.gz; cd node_exporter-1.6.1.linux-amd64
cp node_exporter /usr/local/bin;  chown node_exporter:node_exporter /usr/local/bin/node_exporter