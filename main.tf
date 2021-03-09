resource "exoscale_security_group" "pools" {
  name        = format("%s-pools", var.name)
  description = format("%s security group", var.name)
}

resource "exoscale_security_group_rules" "pools" {
  security_group_id = exoscale_security_group.pools.id

  ingress {
    protocol    = "TCP"
    ports       = ["30000-32767"]
    cidr_list   = ["0.0.0.0/0", "::/0"]
    description = "NodePort TCP services"
  }

  ingress {
    protocol    = "UDP"
    ports       = ["30000-32767"]
    cidr_list   = ["0.0.0.0/0", "::/0"]
    description = "NodePort UDP services"
  }

  ingress {
    protocol    = "TCP"
    ports       = ["10250"]
    cidr_list   = ["0.0.0.0/0", "::/0"]
    description = "Kubelet pods logs"
  }

  ingress {
    protocol                 = "UDP"
    ports                    = ["4789"]
    user_security_group_list = [exoscale_security_group.pools.name]
    description              = "Calico internal traffic"
  }
}

resource "exoscale_sks_cluster" "cluster" {
  zone    = var.zone
  name    = var.name
  version = var.kubernetes_version
}

resource "exoscale_affinity" "pool" {
  for_each = var.pools

  name = format("%s-%s", var.name, each.key)
  type = "host anti-affinity"
}

resource "exoscale_sks_nodepool" "pool" {
  for_each = var.pools

  zone          = var.zone
  cluster_id    = exoscale_sks_cluster.cluster.id
  name          = each.key
  instance_type = each.value.instance_type
  size          = each.value.size

  anti_affinity_group_ids = [exoscale_affinity.pool[each.key].id]
  security_group_ids      = [exoscale_security_group.pools.id]
}
