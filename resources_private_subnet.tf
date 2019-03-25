# Subnet #
resource "aws_subnet" "private" {
  count             = "${var.number_of_private_subnets}"
  vpc_id            = "${aws_vpc.base_vpc.id}"
  cidr_block        = "${cidrsubnet(var.cidr, 8, count.index + 1 + var.number_of_private_subnets)}"
  availability_zone = "${element(local.azs_for_private_subnet, count.index)}"
  tags              = "${merge(var.tags, var.private_subnet_tags, map("Name", format("%s-subnet-private-%s", var.name, element(local.azs_for_private_subnet, count.index))))}"
}


# -------------- Routing -------------- #
# Subnet <--> Route table #
resource "aws_route_table_association" "private" {
  count          = "${var.number_of_private_subnets}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_rt.*.id, count.index)}"
}

resource "aws_route_table" "private_rt" {
  count            = "${var.number_of_private_subnets}"
  vpc_id           = "${aws_vpc.base_vpc.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]
  tags             = "${merge(var.tags, map("Name", format("%s-rt-private-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_route" "route_to_natgw" {
  count            = "${var.number_of_private_subnets}"
  route_table_id   = "${element(aws_route_table.private_rt.*.id, count.index)}"
  #route_table_id         = "${aws_route_table.private_rt.id}" //Reproduce bug

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
}

resource "aws_nat_gateway" "natgw" {
  count         = "${var.number_of_private_subnets}"

  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  #subnet_id     = "${aws_subnet.public.id)}" //Reproduce bug

  allocation_id = "${element(aws_eip.nateip.*.id, count.index)}"
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_eip" "nateip" {
  count = "${var.number_of_private_subnets}"
  vpc   = true
}
