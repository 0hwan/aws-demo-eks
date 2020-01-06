resource "aws_security_group" "eks_worker" {
  name        = "${var.cluster_name}-worker"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.eks.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "${var.cluster_name}-worker"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "eks_worker_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks_worker.id}"
  source_security_group_id = "${aws_security_group.eks_worker.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "demo-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_worker.id}"
  source_security_group_id = "${aws_security_group.eks_cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}
