resource "aws_ebs_volume" "jenkins" {
  availability_zone = var.aws.availability_zones[0]
  size              = 4
  type              = "gp3"

  tags = {
    Name = "jenkins"
  }
}