resource "aws_key_pair" "prometheus_keys" {
  key_name = "prometheus_key_pair"
  public_key = file("./monitoring.pub")
}

resource "aws_instance" "prometheus_follower" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.prometheus_subnet.id
  key_name = aws_key_pair.prometheus_keys.key_name
  security_groups = [
    aws_security_group.prometheus_security_group.id
  ]

  tags = {
    Name = "prometheus-follower"
  }

  user_data = <<EOF
    #!/bin/bash
    wget https://github.com/prometheus/prometheus/releases/download/v2.33.1/prometheus-2.33.1.linux-amd64.tar.gz
    tar xfz prometheus-2.33.1.linux-amd64.tar.gz
    cd prometheus-2.33.1.linux-amd64/
    ./prometheus --config.file=prometheus.yml &
  EOF
}

resource "aws_instance" "prometheus_leader" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.prometheus_subnet.id
  key_name = aws_key_pair.prometheus_keys.key_name
  depends_on = [ aws_instance.prometheus_follower ]
  security_groups = [
    aws_security_group.prometheus_security_group.id
  ]

  tags = {
    Name = "prometheus-leader"
  }

  user_data = <<EOF
    #!/bin/bash
    wget https://github.com/prometheus/prometheus/releases/download/v2.33.1/prometheus-2.33.1.linux-amd64.tar.gz
    tar xfz prometheus-2.33.1.linux-amd64.tar.gz
    cd prometheus-2.33.1.linux-amd64/
    echo "  - job_name: 'federate'
    scrape_interval: 15s
    honor_labels: true
    metrics_path: '/federate'
    params:
      'match[]':
        - '{job="prometheus"}'
        - '{__name__=~"job:.*"}'
    static_configs:
      - targets:
        - '${aws_instance.prometheus_follower.private_ip}:9090'" >> prometheus.yml
    ./prometheus --config.file=prometheus.yml &
  EOF
}