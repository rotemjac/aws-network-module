/*
locals {
  availability_zone = "${data.aws_availability_zones.available.names}"
}
output "all_az" {
  value = "${var.azs}"
}
*/



output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.base_vpc.id}"
}
/*

output "public_route_table_ids" {
  value = ["${aws_route_table.public_rt.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private_rt.*.id}"]
}

output "default_security_group_id" {
  value = "${aws_vpc.base_vpc.default_security_group_id}"
}

output "nat_eips" {
  value = ["${aws_eip.nateip.*.id}"]
}

output "nat_eips_public_ips" {
  value = ["${aws_eip.nateip.*.public_ip}"]
}

output "natgw_ids" {
  value = ["${aws_nat_gateway.natgw.*.id}"]
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}*/
