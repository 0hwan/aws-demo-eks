resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster"
  description = "Cluster communication with Worker Nodes"
  vpc_id      = "${aws_vpc.eks.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-cluster"
  }
}

resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_cluster.id}"
  source_security_group_id = "${aws_security_group.eks_worker.id}"
  to_port                  = 443
  type                     = "ingress"
}

variable "instance_type" {
  default = "m5.large"
  type    = "string"
}
