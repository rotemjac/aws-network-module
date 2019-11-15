# Subnet #
resource "aws_subnet" "private" {
  count             = "${var.number_of_private_subnets}"
  vpc_id            = "${aws_vpc.base_vpc.id}"
  cidr_block        = "${cidrsubnet(var.cidr, 8, count.index + 1 + var.number_of_private_subnets)}"
  availability_zone = "${element(local.azs_for_private_subnet, count.index)}"
  tags              = "${map("Name", format("%s-subnet-private-%s", var.name, element(local.azs_for_private_subnet, count.index)))}"
}


# -------------- Routing -------------- #
# Subnet <--> Route table #
resource "aws_route_table_association" "private" {
  count          = "${var.number_of_private_subnets}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.default_rt.id}"

  #For a case where you want a route table for each subnet (please remember to uncomment all the other places in this file)
  #route_table_id = "${element(aws_route_table.private_rt.*.id, count.index)}"
}

##Instead of creating private route table we'll use the default one
#resource "aws_route_table" "private_rt" {
  ##vpc_id           = "${aws_vpc.base_vpc.id}"
  ##propagating_vgws = ["${var.private_propagating_vgws}"]
  ##tags             = "${merge(var.tags, map("Name", "rt-private"))}"

  #For a case where you want a route table for each subnet (please remember to uncomment all the other places in this file)
  #count            = "${var.number_of_private_subnets}"
  #tags             = "${merge(var.tags, map("Name", format("%s-rt-private-%s", var.name, element(var.azs, count.index))))}"
#}

resource "aws_route" "route_to_natgw" {
  count  =  "${var.number_of_private_subnets > 0 ? 1 : 0}"
  route_table_id         = "${aws_default_route_table.default_rt.id}" //A good practice to attach all private subnets to this route table by default
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.natgw.id}"

  #For a case where you want a NAT GTW for each subnet (please remember to uncomment all the other places in this file)
  #count            = "${var.number_of_private_subnets}"
  #route_table_id   = "${element(aws_route_table.private_rt.*.id, count.index)}"
  #nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"

}

resource "aws_nat_gateway" "natgw" {
  count  = "${var.number_of_private_subnets > 0 ? 1 : 0}"

  # Notice you don't have to specifiy a count explicitly outside!! And it is not related to the count variable one line before
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  #subnet_id     = "${aws_subnet.public.id}" //Reproduce bug
  allocation_id = "${aws_eip.nateip.id}"
  depends_on = ["aws_internet_gateway.igw"]
  tags              = "${map("Name", format("%s-nat_gtw", var.name))}"

  #For a case where you want a NAT GTW for each subnet (please remember to uncomment all the other places in this file)
  #count         = "${var.number_of_private_subnets}"
  #allocation_id = "${element(aws_eip.nateip.*.id, count.index)}"

}

resource "aws_eip" "nateip" {
  count = "${var.number_of_private_subnets > 0 ? 1 : 0}"
  vpc   = true
  tags  = "${map("Name", format("%s-nat_eip", var.name))}"

  #For a case where you want a NAT GTW for each subnet (please remember to uncomment all the other places in this file)
  #count = "${var.number_of_private_subnets}"
}
