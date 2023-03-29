resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Private subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "Private subnet 2"
  }
}

# Create a public subnet for the bastion host
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.MyVPC.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "public-subnet-1"
  }
}

# Create a second public subnet 
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private_database_subnet_1" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Private database subnet 1"
  }
}

resource "aws_subnet" "private_database_subnet_2" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "Private database subnet 2"
  }
}

resource "aws_db_subnet_group" "WPDBSubnetGroup" {
  name       = "wpsubnetgroupdb"
  subnet_ids = [aws_subnet.private_database_subnet_1.id, aws_subnet.private_database_subnet_2.id]

  tags = {
    Name = "WP DB subnet group"
  }
}