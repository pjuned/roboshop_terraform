module "mongodb" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for mongodb"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "mongodb"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
  }

  
  module "catalogue" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for catalogue"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "catalogue"
  }


  module "redis" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for redis"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "redis"
  }


 module "cart" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for cart"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "cart"
  }


 module "user" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for user"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "user"
  }

  module "mysql" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for mysql"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "mysql"
  }



  module "shipping" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for shipping"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "shipping"
  }

  module "rabbitmq" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for rabbitmq"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "rabbitmq"
  }


module "payment" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for payment"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "payment"
  }

  module "web" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for web"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "web"
  }

  module "vpn" {
    source = "../../terraform_aws_sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for vpn"
    vpc_id = data.aws_vpc.default.id
    sg_name = "vpn"
  }


  # openvpn accepting connections from home 
  resource "aws_security_group_rule" "home-openvpn" {
  security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"] # ideally your home IP addresss, but it keeps changing, so we given cidr address.
}



#mongodb accepting connections from openvpn
  resource "aws_security_group_rule" "vpn-mongodb" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id
}


#mongodb accepting connections from catalogue
  resource "aws_security_group_rule" "catalogue-mongodb" {
  source_security_group_id = module.catalogue.sg_id
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id
}

#mongodb accepting connections from user
  resource "aws_security_group_rule" "user-mongodb" {
  source_security_group_id = module.user.sg_id
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id
}

#redis accepting connections from vpn
  resource "aws_security_group_rule" "vpn-redis" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.redis.sg_id
}


#redis accepting connections from user
  resource "aws_security_group_rule" "user-redis" {
  source_security_group_id = module.user.sg_id
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = module.redis.sg_id
}

#redis accepting connections from cart
  resource "aws_security_group_rule" "cart-redis" {
  source_security_group_id = module.cart.sg_id
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = module.redis.sg_id
}

#mysql accepting connections from vpn
  resource "aws_security_group_rule" "vpn-mysql" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.mysql.sg_id
}

#mysql accepting connections from shipping
  resource "aws_security_group_rule" "shipping-mysql" {
  source_security_group_id = module.shipping.sg_id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = module.mysql.sg_id
}

#rabbitmq accepting connections from vpn
  resource "aws_security_group_rule" "vpn-rabbitmq" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.rabbitmq.sg_id
}

#rabbitmq accepting connections from payment
  resource "aws_security_group_rule" "payment-rabbitmq" {
  source_security_group_id = module.payment.sg_id
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  security_group_id = module.rabbitmq.sg_id
}



#catalogue accepting connections from vpn
  resource "aws_security_group_rule" "vpn-catalogue" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.catalogue.sg_id
}

#catalogue accepting connections from web
  resource "aws_security_group_rule" "web-catalogue" {
  source_security_group_id = module.web.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.catalogue.sg_id
}

#catalogue accepting connections from cart
  resource "aws_security_group_rule" "cart-catalogue" {
  source_security_group_id = module.cart.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.catalogue.sg_id
}

#user accepting connections from vpn
  resource "aws_security_group_rule" "vpn-user" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.user.sg_id
}

#user accepting connections from web
  resource "aws_security_group_rule" "web-user" {
  source_security_group_id = module.web.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.user.sg_id
}

#user accepting connections from payment
  resource "aws_security_group_rule" "payment-user" {
  source_security_group_id = module.payment.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.user.sg_id
}


#cart accepting connections from vpn
  resource "aws_security_group_rule" "vpn-cart" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.cart.sg_id
}

#cart accepting connections from web
  resource "aws_security_group_rule" "web-cart" {
  source_security_group_id = module.web.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.cart.sg_id
}

#cart accepting connections from shipping
  resource "aws_security_group_rule" "shipping-cart" {
  source_security_group_id = module.shipping.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.cart.sg_id
}

#cart accepting connections from payment
  resource "aws_security_group_rule" "payment-cart" {
  source_security_group_id = module.payment.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.cart.sg_id
}

#shipping accepting connections from vpn
  resource "aws_security_group_rule" "vpn-shipping" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.shipping.sg_id
}

#shipping accepting connections from web
  resource "aws_security_group_rule" "web-shipping" {
  source_security_group_id = module.web.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.shipping.sg_id
}

#payment accepting connections from vpn
  resource "aws_security_group_rule" "vpn-payment" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.payment.sg_id
}

#payment accepting connections from web
  resource "aws_security_group_rule" "web-payment" {
  source_security_group_id = module.web.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.payment.sg_id
}


#web accepting connection from vpn
resource "aws_security_group_rule" "vpn-web" {

  source_security_group_id = module.vpn.sg_id
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.web.sg_id
}

##web accepting connection from internet
resource "aws_security_group_rule" "internet-web" {
  cidr_blocks = ["0.0.0.0/0"]
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = module.web.sg_id
  
}