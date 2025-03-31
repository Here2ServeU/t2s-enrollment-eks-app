output "cluster_name" {
  value = module.eks.cluster_name
}

output "kubeconfig" {
  value     = module.eks.kubeconfig
  sensitive = true
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}
