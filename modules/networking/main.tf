resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "${var.project}-${var.environment}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.project}-${var.environment}-igw" }
}

# Subnets (2 AZs)
resource "aws_subnet" "public" {
  for_each          = toset(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, index(var.public_subnet_cidrs, each.value))
  tags = { Name = "${var.project}-${var.environment}-public-${index(var.public_subnet_cidrs, each.value)+1}" }
}

resource "aws_subnet" "private" {
  for_each          = toset(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = element(data.aws_availability_zones.available.names, index(var.private_subnet_cidrs, each.value))
  tags = { Name = "${var.project}-${var.environment}-private-${index(var.private_subnet_cidrs, each.value)+1}" }
}

data "aws_availability_zones" "available" {}

# NAT (1x) in a public subnet
resource "aws_eip" "nat" { domain = "vpc" }
resource "aws_nat_gateway" "nat" {
  subnet_id     = element(values(aws_subnet.public)[*].id, 0)
  allocation_id = aws_eip.nat.id
  depends_on    = [aws_internet_gateway.igw]
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route { 
    cidr_block = "0.0.0.0/0"
          gateway_id = aws_internet_gateway.igw.id 
          }
}
resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" { vpc_id = aws_vpc.this.id }
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

output "vpc_id"             { value = aws_vpc.this.id }
output "public_subnet_ids"  { value = values(aws_subnet.public)[*].id }
output "private_subnet_ids" { value = values(aws_subnet.private)[*].id }
