resource "aws_instance" "Webserver" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ami_key_pair_name
  subnet_id     = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.publicSG.id]
  user_data = base64encode(templatefile("${path.module}/LAMPandWP.sh", local.vars))
  tags = {
    Name = "Wordpress"
  }
  depends_on = [aws_rds_cluster_instance.clusterinstance]
}