resource "aws_vpc" "base_vpc" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.base_vpc.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-igw", var.name)))}"
}
