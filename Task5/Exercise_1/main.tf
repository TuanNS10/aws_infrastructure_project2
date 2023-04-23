# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAVROHAM24YBGL4VD6"
  secret_key = "Xciv0zR2LyHJSDMjRuo3VINY1LLNOVeMbqInstkz"
  token      = "FwoGZXIvYXdzEOj//////////wEaDBZC3Ok0SYlFFieySSLVAT4eCUj6iUh+xPkLruoYnli+nAlgd6IK9rVxmAe6rnp0oKzdUw4+9Js7wL38Vxi0FHg5WhK44REk4SQUpLmEoQrYCw+9WioVffG0tE3nnS0e3Vwmsa5DaXlNt1LoMZH8+lpXI/TsEJyDJSRYY2cgPjvFgLPft7pMy1jYqI1GMG7wD5r5l1L24C9gJehETKEVAi/BqkOA0v6IsYdkf19KVmumq4ItWgo9UCzhk/V+7xtXnlAF2v7H0XvZh6CZNyFFMxJemPrpFLA/bJN0Y7NzmHq1s1BlxCj0o5OiBjItK51eej/NqOU4YizZM9j1ubOMXGRKLwgqHfNDOAXVFeeJrjQGqRlks8XojFLW"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity-t2" {
  ami = "ami-02396cdd13e9a1257"
  instance_type = "t2.micro"
  subnet_id = "subnet-0045d8187ff978839"
  count = 4
  tags = {
    Name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "udacity-m4" {
  ami = "ami-02396cdd13e9a1257"
  instance_type = "m4.large"
  subnet_id = "subnet-0045d8187ff978839"
  count = 2
  tags = {
    Name = "Udacity M4"
  }
}