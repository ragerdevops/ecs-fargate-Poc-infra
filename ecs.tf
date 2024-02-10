module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  cluster_name = "ecs-integrated"
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
  services = {
    ecs-frontend = {
      cpu    = 2048
      memory = 4096
      # Container definition(s)
      container_definitions = {
        ecs-frontend = {
          cpu       = 2048
          memory    = 4096
          essential = true
          network_mode = "awsvpc"
          image     = "URL-IMAGE"
          environment = [
           { name = "ECS_BACKEND_URL", value = "http://ecs-backend" },
           { name = "ECS_BACKEND_PORT", value = "8080" },
        # Agrega otras variables de entorno según sea necesario
           ],
          port_mappings = [
            {
              name          = "ecs-frontend"
              containerPort = 80
              protocol      = "http"
            }
          ]
          # Example image used requires access to write to root filesystem
          readonly_root_filesystem = false
          enable_cloudwatch_logging = true
          memory_reservation = 100
        }
      }
            log_configuration = {
            logDriver = "awslogs"
            options = {
              Name                    = "ecs-frontend"
              region                  = "eu-west-1"
              delivery_stream         = "ecs"
            }
       }
      service_connect_configuration = {
        namespace = "test-namespace"
        service = {
          client_alias = {
            port     = 80
            dns_name = "ecs-frontend"
          }
          port_name      = "ecs-frontend"
          discovery_name = "ecs-frontend"
        }
      }

      subnet_ids = module.vpc.private_subnets
      security_group_rules = {
        alb_ingress_80 = {
          type                     = "ingress"
          from_port                = 80
          to_port                  = 80
          protocol                 = "tcp"
          description              = "Service port"
          cidr_blocks = module.vpc.private_subnets_cidr_blocks
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    ecs-backend = {
      cpu    = 1024
      memory = 4096
      # Container definition(s)
      container_definitions = {
        ecs-backend = {
          cpu       = 512
          memory    = 1024
          essential = true
          network_mode = "awsvpc"
          image     = "URL-IMAGE"
          port_mappings = [
            {
              name          = "ecs-backend"
              containerPort = 8080
              protocol      = "http"
            }
          ]
          # Example image used requires access to write to root filesystem
          readonly_root_filesystem = false
          enable_cloudwatch_logging = true
          memory_reservation = 100
        }
      }
      log_configuration = {
            logDriver = "awslogs"
            options = {
              Name                    = "ecs-backend"
              region                  = "eu-west-1"
              delivery_stream         = "ecs"
            }
       }
      service_connect_configuration = {
        namespace = "test-namespace"
        service = {
          client_alias = {
            port     = 8080
            dns_name = "ecs-backend"
          }
          port_name      = "ecs-backend"
          discovery_name = "ecs-backend"
        }
      }
      subnet_ids = module.vpc.private_subnets
      security_group_rules = {
        vpc_ingress = {
          type                     = "ingress"
          from_port                = 8080
          to_port                  = 8080
          protocol                 = "All"
          description              = "Connect from VPC"
          cidr_blocks              = module.vpc.private_subnets_cidr_blocks
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
  depends_on = [ 
    aws_service_discovery_private_dns_namespace.namespace_cluster
   ]
}
resource "aws_service_discovery_private_dns_namespace" "namespace_cluster" {
    name = "test-namespace"
    vpc = module.vpc.vpc_id
      depends_on = [ 
    module.vpc
   ]
}