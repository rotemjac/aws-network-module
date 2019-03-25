/*
resource "aws_default_network_acl" "my_nacl" {

  #Cannot be set for default nacl
  #vpc_id     = "${aws_vpc.base_vpc.id}"


  #subnet_ids = ["${aws_subnet.public.id}","${aws_subnet.private.id}"]
  default_network_acl_id = ""

  depends_on = ["aws_vpc.base_vpc"]
}

resource "aws_network_acl_rule" "nacl_inbound_80" {
  network_acl_id = "${aws_default_network_acl.my_nacl.id}"
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0" # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "nacl_inbound_ssh" {
  network_acl_id = "${aws_default_network_acl.my_nacl.id}"
  rule_number    = 201
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0" # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "nacl_outbound_all" {
  network_acl_id = "${aws_default_network_acl.my_nacl.id}"
  rule_number    = 202
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0" # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
}*/
