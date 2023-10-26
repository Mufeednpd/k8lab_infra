# Generate ansible inventory file

resource "local_file" "ansible_inventory" {
  content = templatefile(
    "${path.cwd}/ansible/hosts.tftpl", {
      hostname    = "worker", workernode_ip = "${data.aws_instance.k8worker.*.public_ip}",
      k8master_ip = "${data.aws_instance.k8master.*.public_ip}",
      jenkins_ip  = "${data.aws_instance.jenkins.*.public_ip}"
  })
  filename   = "${path.cwd}/ansible/hosts"
  depends_on = [ aws_instance.jenkins]
}
