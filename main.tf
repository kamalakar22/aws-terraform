# Define the VPC
resource "aws_vpc" "github" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "github"
  }
}

# Define the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.github.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Replace with your desired AZ
  
  tags = {
    Name = "public-subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.github.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"  # Replace with your desired AZ
  
  tags = {
    Name = "private-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.github.id

  tags = {
    Name = "github-igw"
  }
}

# Create a public route table and associate it with the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.github.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a NAT gateway and elastic IP for the private subnet
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "github-nat-gateway"
  }
}

# Create a private route table and associate it with the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.github.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
