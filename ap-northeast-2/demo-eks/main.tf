module "demo-eks" {
  source = "../../modules/projects/eks"

  cluster_name = "demo-eks"
  cidr_block_prefix = "10.0" # <- AWS 계정의 VPC에 맞추어 수정해줍니다.
}
