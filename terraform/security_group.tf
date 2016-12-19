# Security Group(App用)
resource "aws_security_group" "app" {
    name        = "tf_web"
    description = "It is a security group on http of tf_vpc"
    vpc_id      = "${aws_vpc.tf_vpc.id}"
    tags {
        Name = "${var.aws_security_group_web_name}"
    }
}

# InboundRules SSH
resource "aws_security_group_rule" "ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.app.id}"
}

# InboundRules HTTP
resource "aws_security_group_rule" "web" {
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.app.id}"
}

# OutboundRules ALL
resource "aws_security_group_rule" "all" {
    type              = "egress"
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.app.id}"
}

# Security Group（DB用）
resource "aws_security_group" "db" {
    name        = "db_server"
    description = "It is a security group on db of tf_vpc."
    vpc_id      = "${aws_vpc.tf_vpc.id}"
    tags {
        Name = "${var.aws_security_group_db_name}"
    }
}

# InboundRules MySQL
resource "aws_security_group_rule" "db" {
    type                     = "ingress"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    source_security_group_id = "${aws_security_group.app.id}"
    security_group_id        = "${aws_security_group.db.id}"
}
