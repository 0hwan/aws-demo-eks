resource "aws_vpc" "eks" {
  cidr_block = "${var.cidr_block_prefix}.0.0/16"

  tags = "${
    map(
      "Name", "${var.cluster_name}",
      "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_subnet" "eks" {
  count = "${length(local.zone_names)}"
  # count = local.zone_names.length

  availability_zone = "${local.zone_names[count.index]}"
  cidr_block        = "${var.cidr_block_prefix}.${count.index}.0/24"
  vpc_id            = "${aws_vpc.eks.id}"

  tags = {
    "Name"                                      = "${var.cluster_name}-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "eks" {
  vpc_id = "${aws_vpc.eks.id}"

  tags = {
    Name = "${var.cluster_name}"
  }
}

resource "aws_route_table" "eks" {
  vpc_id = "${aws_vpc.eks.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks.id}"
  }

  tags = {
    Name = "${var.cluster_name}"
  }
}


resource "aws_route_table_association" "eks" {
  count = 2

  subnet_id = "${aws_subnet.eks.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks.id}"
}



