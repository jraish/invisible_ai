# invisible_ai
Invisible AI coding exercise

## Installation
If you don't have terraform installed, go ahead and do that. I'd recommend installing with a version manager like `asdf`, but that's your call. If you want to use `asdf`, the installation page is [here](https://asdf-vm.com/), and the terraform plugin is [here](https://github.com/asdf-community/asdf-hashicorp). I'm using terraform 1.7.4

Navigate to the `terraform` folder and run
```
terraform init
```
to install the modules used in this terraform config.

The terraform script also assumes you have private and public SSH keys in the terraform directory called `monitoring` and `monitoring.pub`, respectively. Those aren't actually necessary - but if you don't use them, comment out the references to keys in the ec2 file or terraform will be sad.

Finally, this repo assumes you have AWS secret and access keys saved as environment variables. I don't think running terraform locally with env variables is necessarily ideal, but I would imagine that in a production environment this would be run as part of a deployment pipeline that had those secrets saved; another option would be to assume a specified IAM role with restricted permissions.

When that's all set up, run 
```
terraform apply
```
from the root of the terraform directory.

## Assumptions
I mentioned a few things in installation that I'd change if this were running in production.

Another thing is the security group permissions. They're *quite* permissive here, and they should be a lot tighter. If this were running in production, I'd rather put all of this in a private subnet with no ingress access to the outside internet, and put some sort of consumer instance in the public subnet that could read these metrics and make them available to the world.

## Functionality
This terraform repo should create a VPC and two EC2 instances running Ubuntu and Prometheus, with the follower scraping data from the leader. But "should" is a key word here. More on that below.

## Road blocks
I hit a few snags in this assignment that I'd love to discuss.

I couldn't find any way to SSH into these instances, and this is after reading through documentation for substantially longer than the two hours I was meant to spend on this. I'm wondering if the problem I'm facing is that the sandbox environment doesn't actually allow SSH access from outside.

I initially wanted to provision the instances with Terraform and then configure Prometheus with Ansible, as any God fearing engineer would. The problem is that one of Ansible's selling points is that it relies on regular ol' SSH, which I couldn't get to work (see above). So then I investigated a second option to configure the instances: Ansible over SSM. The problem I hit there was that I didn't have permissions to create IAM roles, which that would require. Fine. So then I tried to use a `remote-exec` provisioner in Terraform directly (which I don't love, since it seems a little janky and brittle), but that also required an ability to SSH into the machine. My last try at doing this in a clean way was to load the Prometheus files into an S3 bucket which the EC2s could pull from, but that also required making IAM roles, which I couldn't do.

So.

The Terraform script is now launching both instances, and using the `user_data` parameter to install Prometheus and federate the two servers. But I'm having trouble accessing the servers in any way once they're up to actually see how they're doing. 

I could probably come up with some alternative ways to complete this assignment, but I'd like to turn it over to you all and chat about it first - I'd like to see if I'm missing something obvious, and if there's some markedly better way to go about this!