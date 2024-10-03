resource "aws_internet_gateway" "k8s-vpc-igw" {
  vpc_id = aws_vpc.k8s-vpc.id
  tags = {
    Name = "k8s-igw"
  }
}

