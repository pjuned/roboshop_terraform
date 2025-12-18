module "mongodb" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.rhel.id
  name = "${local.ec2-name}-mongodb"
  instance_type = "t3.small"

  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]

  subnet_id = local.database_subnet_id

  tags = merge(
    var.common_tags,
    {
        component = "mongodb"
    },
    {
        Name = "${local.ec2-name}-mongodb"
    }
  )
}

# module "redis" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-redis"
#   instance_type = "t3.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]

#   subnet_id = local.database_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "redis"
#     },
#     {
#         Name = "${local.ec2-name}-redis"
#     }
#   )
# }

# module "mysql" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-mysql"
#   instance_type = "t3.small"

#   vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]

#   subnet_id = local.database_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "mysql"
#     },
#     {
#         Name = "${local.ec2-name}-mysql"
#     }
#   )
# }

# module "rabbitmq" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-rabbitmq"
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]

#   subnet_id = local.database_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "rabbitmq"
#     },
#     {
#         Name = "${local.ec2-name}-rabbitmq"
#     }
#   )
# }

# module "catalogue" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-catalogue"
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

#   subnet_id = local.private_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "catalogue"
#     },
#     {
#         Name = "${local.ec2-name}-catalogue"
#     }
#   )
# }

# module "user" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-user"
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.user_sg_id.value]

#   subnet_id = local.private_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "user"
#     },
#     {
#         Name = "${local.ec2-name}-user"
#     }
#   )
# }

# module "cart" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-cart"
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.cart_sg_id.value]

#   subnet_id = local.private_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "cart"
#     },
#     {
#         Name = "${local.ec2-name}-cart"
#     }
#   )
# }


# module "shipping" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-shipping"
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.shipping_sg_id.value]

#   subnet_id = local.private_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "shipping"
#     },
#     {
#         Name = "${local.ec2-name}-shipping"
#     }
#   )
# }

# module "payment" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-payment"
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.payment_sg_id.value]

#   subnet_id = local.private_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "payment"
#     },
#     {
#         Name = "${local.ec2-name}-payment"
#     }
#   )
# }

# module "web" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-web"
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.web_sg_id.value]

#   subnet_id = local.public_subnet_id

#   tags = merge(
#     var.common_tags,
#     {
#         component = "web"
#     },
#     {
#         Name = "${local.ec2-name}-web"
#     }
#   )
# }

# #creating ansible server to provision and configure all the EC2 instances
# module "ansible" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.rhel.id
#   name = "${local.ec2-name}-ansible"
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]

#   subnet_id = data.aws_subnet.selected.id #default vpc 1b subnet

#   user_data = file("ec2-provision.sh")

#   tags = merge(
#     var.common_tags,
#     {
#         component = "ansible"
#     },
#     {
#         Name = "${local.ec2-name}-ansible"
#     }
#   )
# }





module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  #version = "2.0.0" #  modules/records submodule is avilable only till 5.0.0

  zone_id = var.zone_id  # <- hosted zone ID
  zone_name = var.zone_name

  records = {
    mongodb = {
      name    = "mongodb"
      type    = "A"
      ttl     = 1
      records = [module.mongodb.private_ip]
    }
    # redis = {
    #   name    = "redis"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.redis.private_ip]
    # }
    # mysql = {
    #   name    = "mysql"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.mysql.private_ip]
    # }
    # rabbitmq = {
    #   name    = "rabbitmq"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.rabbitmq.private_ip]
    # }
    # catalogue = {
    #   name    = "catalogue"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.catalogue.private_ip]
    # }
    # user = {
    #   name    = "user"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.user.private_ip]
    # }
    # cart = {
    #   name    = "cart"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.cart.private_ip]
    # }
    # shipping = {
    #   name    = "shipping"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.shipping.private_ip]
    # }
    # payment = {
    #   name    = "payment"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.payment.private_ip]
    # }
    # web = {
    #   name    = "web"
    #   type    = "A"
    #   ttl     = 1
    #   records = [module.web.private_ip]
    # }
  }
}



