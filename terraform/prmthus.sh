useradd -M -r -s /bin/false prometheus; mkdir /etc/prometheus /var/lib/prometheus;
wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz
tar xzf prometheus-2.47.0.linux-amd64.tar.gz; cd prometheus-2.47.0.linux-amd64
cp {prometheus,promtool} /usr/local/bin/;  chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
cp -r {consoles,console_libraries} /etc/prometheus/; cp prometheus.yml /etc/prometheus/prometheus.yml
chown -R prometheus:prometheus /etc/prometheus; chown prometheus:prometheus /var/lib/prometheus