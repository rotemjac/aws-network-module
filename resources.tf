resource "aws_vpc" "base_vpc" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${map("Name", format("%s-base-vpc", var.name))}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.base_vpc.id}"
  tags   = "${map("Name", format("%s-igw", var.name))}"
}

resource "aws_default_route_table" "default_rt" {
  default_route_table_id = "${aws_vpc.base_vpc.default_route_table_id}"
  tags                   = "${map("Name", format("%s-aws_default_rtz", var.name))}"
}

resource "aws_main_route_table_association" "main_rt_association" {
  vpc_id         = "${aws_vpc.base_vpc.id}"
  route_table_id = "${aws_default_route_table.default_rt.id}"
}
