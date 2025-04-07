# create VPC
resource "aws_vpc" "basel-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "basel-vpc"
  }
}

# create internet gateway
resource "aws_internet_gateway" "basel-igw" {
  vpc_id = aws_vpc.basel-vpc.id
  tags = {
    Name = "basel-igw"
  }
}

# create Public Subnet 1
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.basel-vpc.id
  cidr_block              = var.public_subnets_cidrs[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "basel-public-subnet-1"
  }
}

# create Public Subnet 2
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.basel-vpc.id
  cidr_block              = var.public_subnets_cidrs[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "basel-public-subnet-2"
  }
}

# create Private Subnet 1
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.basel-vpc.id
  cidr_block        = var.private_subnets_cidrs[0]
  availability_zone = var.azs[0]
  tags = {
    Name = "basel-private-subnet-1"
  }
}

# create Private Subnet 2
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.basel-vpc.id
  cidr_block        = var.private_subnets_cidrs[1]
  availability_zone = var.azs[1]
  tags = {
    Name = "basel-private-subnet-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.basel-vpc.id
  tags = {
    Name = "basel-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.basel-igw.id
}

# link Public Subnet 1 with Route Table
resource "aws_route_table_association" "public_assoc1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

# link Public Subnet 2 with Route Table
resource "aws_route_table_association" "public_assoc2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# create Security Group for public Instance
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  vpc_id      = aws_vpc.basel-vpc.id
  description = "Allow inbound HTTP/SSH from anywhere"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

# create Security Group for Private Instances 
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  vpc_id      = aws_vpc.basel-vpc.id
  description = "Allow all traffic from within VPC"

  ingress {
    description = "Allow all from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

# create Security Group for Public Load Balancer
resource "aws_security_group" "public_lb_sg" {
  name        = "public-lb-sg"
  vpc_id      = aws_vpc.basel-vpc.id
  description = "Allow inbound HTTP/HTTPS/SSH for public LB"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-lb-sg"
  }
}

# create Security Group for Private Load Balancer 
resource "aws_security_group" "private_lb_sg" {
  name        = "private-lb-sg"
  vpc_id      = aws_vpc.basel-vpc.id
  description = "Allow inbound HTTP/SSH from within VPC for private LB"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-lb-sg"
  }
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-eip"
  }
}

# Create NAT Gateway 
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public1.id  

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.basel-igw]
}

# create Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.basel-vpc.id

  tags = {
    Name = "private-rt"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route" "private_default_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_assoc1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}
