
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_route_table" "myapp-rt" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name : "${var.env_prefix}-rt"
  }

}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name : "${var.env_prefix}-igw"
  }
}

resource "aws_route_table_association" "myapp-rt-ass" {
  subnet_id      = aws_subnet.myapp-subnet.id
  route_table_id = aws_route_table.myapp-rt.id
}

resource "aws_security_group" "myapp-sg" {
  name   = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.myip]

  }

  ingress {
    description = "nginx-webserver access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name : "${var.env_prefix}-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

/*resource "aws_key_pair" "ssh-key" {
  key_name   = "babah-key"
  public_key = file(var.public_key_location)
}*/

resource "aws_instance" "myapp-webserver" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance-type

  subnet_id              = aws_subnet.myapp-subnet.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone      = var.avail_zone

  associate_public_ip_address = true
  key_name                    = "terraform-key"  //aws_key_pair.ssh-key.key_name

  tags = {
    Name : "${var.env_prefix}-server"
  }
  user_data = file("entry-script.sh")
}





/*output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
  
}*/