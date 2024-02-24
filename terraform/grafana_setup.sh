yum update -y; yum install docker -y
service docker start; docker pull grafana/grafana
docker run --name grafana-aws -d -p 8080:3000 grafana/grafana