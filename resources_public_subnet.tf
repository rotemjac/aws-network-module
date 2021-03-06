# Subnet #
resource "aws_subnet" "public" {
  count             = "${var.number_of_public_subnets}"
  vpc_id            = "${aws_vpc.base_vpc.id}"
  cidr_block        = "${cidrsubnet(var.cidr, 8, count.index + 1)}"
  availability_zone = "${element(local.azs_for_public_subnet, count.index)}"
  tags              = "${map("Name", format("%s-subnet-public-%s", var.name, element(local.azs_for_public_subnet, count.index)))}"
  map_public_ip_on_launch = true
}

# -------------- Routing -------------- #
# Subnet <--> Route table #
resource "aws_route_table_association" "public" {
  count          = "${var.number_of_public_subnets}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"

  #For a case where you want a route table for each subnet (please remember to uncomment all the other places in this file)
  #route_table_id = "${element(aws_route_table.public_rt.*.id , count.index)}"
}

resource "aws_route_table" "public_rt" {
  vpc_id           = "${aws_vpc.base_vpc.id}"
  propagating_vgws = ["${var.public_propagating_vgws}"]
  tags             = "${map("Name", format("%s-rt-public", var.name))}"

  #For a case where you want a route table for each subnet (please remember to uncomment all the other places in this file)
  #count            = "${var.number_of_public_subnets}"
  #tags             = "${merge(var.tags, map("Name", format("%s-rt-public", var.name)))}"
}

resource "aws_route" "route_to_igw" {
  route_table_id         = "${aws_route_table.public_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"

 #For a case where you want a route table for each subnet (please remember to uncomment all the other places in this file)
 #route_table_id         = "${element(aws_route_table.public_rt.*.id, count.index)}"
 #count                  = "${var.number_of_public_subnets}"
}

