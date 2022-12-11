terraform {
  required_providers{
    aws = {

        source = "hashicorp/aws"
        version = "~>3.0"
    }
  }
}


provider "aws" {

    profile = "default"
    region = "ap-south-1"

}

resource "aws_instance" "jenkins_server" {

    ami = "ami-074dc0a6f6c764218"
    instance_type = "t2.micro"
    security_groups = [data.aws_security_group.my_sg.name , data.aws_security_group.jenkins_sg.name]
    key_name = "EC2Key_Mumbai_Region"

    user_data = <<EOF
    #!/bin/bash
    # Use this for your user data (script without newlines)
    # install jenkins (Linux 2 version)
    yum update -y
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    amazon-linux-extras install java-openjdk11 -y
    yum install jenkins -y
    yum install git -y
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    yum -y install terraform
    service jenkins start
    cat /var/lib/jenkins/secrets/initialAdminPassword >/home/ec2-user/pass.txt
    EOF

    tags = {
      "Name" = "**Jenkins-Server**"
      "requested by" = "Janakiraman"
    }
  
}


data "aws_vpc" "my_vpc" {

    id = "vpc-0762d741e0f27c7a7"
  
}

data "aws_security_group" "my_sg" {
  
  id = "sg-038bd680e2b37923a"

}

data "aws_security_group" "jenkins_sg" {
  
  id = "sg-0d8f047b000d484ed"

}