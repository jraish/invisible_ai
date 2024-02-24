data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["amazon"]
}

data "cloudinit_config" "prmthus_service" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.root}/prmthus.sh")
  }

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          encoding    = "b64"
          content     = filebase64("${path.root}/prometheus.service.txt")
          path        = "/etc/systemd/system/prometheus.service"
          owner       = "prometheus:prometheus"
          permissions = "0755"
        },
      ]
    })
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.root}/prmthus_start.sh")
  }
}

locals {
  prometheus_lead_config = yamlencode({
    global = {
      scrape_interval = "1m",
    },
    rule_files = [
      "/etc/prometheus/prometheus.rules.yaml",
    ],
    alerting = {
      alertmanagers : [
        {
          static_configs = [
            {
              targets = [
                "localhost:9093",
              ]
            }
          ],
        }
      ],
    },
  })
}