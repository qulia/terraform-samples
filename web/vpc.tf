# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block = var.network_address_space

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

}

# Create as many instance count subnets picking the corresponding
# availability zone
resource "aws_subnet" "subnets" {
  count                   = var.subnet_count
  cidr_block              = cidrsubnet(var.network_address_space, 8, count.index + 1)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta-subnet1" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rtb.id
}