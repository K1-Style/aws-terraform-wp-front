## EC2 + PrepareWordPress.sql

data "template_file" "wp_ddl_sql" {
  template = "${file("${path.module}/ddl/prepareWordPress.sql.tpl")}"

  vars {
    aws_db_wp = "${var.aws_db_wp}"
    aws_db_wp_username = "${var.aws_db_wp_username}"
  }
}

# EC2
resource "aws_instance" "web" {
    ami                         = "ami-0c11b26d"  # 東京リージョンにある Amazon Linux AMI の ID を指定する
    instance_type               = "t2.micro"
    key_name                    = "${var.aws_key_name}"  # EC2 に登録済の Key Pairs を指定する
    vpc_security_group_ids      = ["${aws_security_group.app.id}"]
    subnet_id                   = "${aws_subnet.public_web.id}"
    associate_public_ip_address = "true"
    root_block_device = {
        volume_type = "gp2"
        volume_size = "20"
    }
    ebs_block_device = {
        device_name = "/dev/sdf"
        volume_type = "gp2"
        volume_size = "50"
    }
    tags {
        Name = "${var.aws_instance_name}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update -y",
            "sudo yum install epel-release",
            "rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm",
            "sudo yum install --enablerepo=remi,remi-php70 httpd php php-pear php-mysql php-mbstring php-gd php-xml php-mcrypt php-pecl-apc -y",
            "sudo yum install mysql -y",
            "wget -O /tmp/wordpress-ja.tar.gz http://ja.wordpress.org/latest-ja.tar.gz",
            "sudo tar zxf /tmp/wordpress-ja.tar.gz -C /opt",
            "sudo ln -s /opt/wordpress /var/www/html/",
            "sudo chown -R apache:apache /opt/wordpress",
            "sudo chkconfig httpd on",
            "sudo killall -9 httpd",
            "sudo rm -f /var/lock/subsys/httpd",
            "sudo service httpd start",
            "sudo service httpd status",
            "sudo tee /home/ec2-user/prepareWordPress.sql >> EOF",
            "${data.template_file.wp_ddl_sql.rendered}",
            "EOF",
            "mysql -u ${var.aws_db_username} -p${var.aws_db_password} -h ${aws_db_instance.db.address} < /home/ec2-user/prepareWordPress.sql"
        ]
        connection {
            user = "ec2-user"
            private_key = "${file("${path.module}/ssh_key/${var.ssh_key_file}")}"
            agent = false
        }
    }
}
