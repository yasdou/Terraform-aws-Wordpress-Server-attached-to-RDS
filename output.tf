output "Webserver_DNS_addr" {
  value = aws_instance.Webserver.public_dns
}

output "RDS_Endpoint" {
    value = aws_rds_cluster.RDSWP.endpoint
}