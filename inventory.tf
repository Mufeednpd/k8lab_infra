# Generate ansible inventory file

resource "local_file" "ansible_inventory" {
  content = templatefile(
    "${path.cwd}/ansible/hosts.tftpl", {
      hostname    = "worker", 
      k8worker_az_a_ip = "${data.aws_instance.k8workers_az_a.*.private_ip}",
      k8worker_az_b_ip = "${data.aws_instance.k8workers_az_b.*.private_ip}"
      k8master_ip = "${data.aws_instance.k8master.*.private_ip}",
      jenkins_ip  = "${data.aws_instance.jenkins.*.private_ip}"
  })
  filename   = "${path.cwd}/ansible/hosts"
  depends_on = [ aws_instance.jenkins]
}
