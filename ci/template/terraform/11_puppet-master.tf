module "puppet_master" {
  source = "github.com/conjurdemos/conjur-intro//terraform_modules/puppet/master?ref=puppet-windows"


  vpc_id = "${data.aws_vpc.selected.id}"
  resource_prefix = "${var.resource_prefix}"
  ssh_key_name = "${aws_key_pair.generated_key.key_name}"
  ssh_key_pem = "${tls_private_key.ssh_access_key.private_key_pem}"
}

output "puppet_master_public" {
  value = "${module.puppet_master.public_dns}"
}

output "puppet_master_private" {
  value = "${module.puppet_master.private_dns}"
}
