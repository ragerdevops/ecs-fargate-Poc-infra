# Despliegue de Aplicación con AWS App Runner y Terraform

Este repositorio contiene el código fuente de Terraform para la creación y configuración de la infrastructura necesaria para desplegar ECS Fargate + Service connect + VPC, así como la pipeline de GitHub Actions para automatizar el proceso de despliegue.

## Estructura del Repositorio

- **ecr.tf:** Este fichero contiene un ejemplo del módulo de Terraform para la creación de un ECR de la comunidad:
- [Module] (https://github.com/terraform-aws-modules/terraform-aws-ecr).
- **ecs.tf:** Este fichero contiene un ejemplo de del módulo de Terraform para la creación y configuración de ECS Fargate de la comunidad:
- [Module] (https://github.com/terraform-aws-modules/terraform-aws-ecs)
- **.github/workflows:** Aquí se encuentra la pipeline necesaria para ejecutar el terraform.
- **vpc.tf:** Este fichero contiene un ejemplo de del módulo de Terraform para la creación y configuración de VPC de la comunidad:
- [Module] (https://github.com/terraform-aws-modules/terraform-aws-vpc)
## Código Fuente de las APP Front + Back

**Nota:** El código fuente de la aplicación no está incluido en este repositorio. Lo podréis encontrar en el siguiente repositorio:
- [Front] (https://github.com/ragerdevops/ecs-front-dummy)
- [Back] (https://github.com/ragerdevops/ecs-back-dummy)

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado lo siguiente:

- [GIT] (https://git-scm.com/)

## Despliegue de la Aplicación

1. **Configuración de las Credenciales en GitHub:**
   - Configura las [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) con las credenciales de AWS necesarias para la pipeline. En este caso deberás de configurarlas en tu repositorio.

2. **Configuración de AWS App Runner:**
   - Ajusta el fichero provider.tf para indicar la region donde quieres desplegar tu infrastructura.
   - Modifica backend.tf para apuntar a tu bucket s3 para almacenar el estado de terraform.
   - Ajusta las configuraciones necesarias en el fichero ecs.tf apuntando a tus repositorios de imagenes ECR según tus necesidades y VPC indicando los rangos de RED que necesitas

3. **Despliegue Automático con GitHub Actions:**
   - Cada vez que realices un push a la rama `main`, la pipeline de GitHub Actions se activará automáticamente, desencadenando el despliegue de la infrastructura necesaria para poder deployar nuestras nuevas task definition.


## Importante: Entorno de Prueba (PoC)

Este repositorio está destinado para propósitos de prueba y es un entorno de prueba de concepto (PoC). No se recomienda utilizar este entorno para aplicaciones de producción. Asegúrate de comprender las limitaciones y configuraciones específicas para PoC antes de implementar en entornos de producción.

## Contribuciones

¡Contribuciones son bienvenidas! Si encuentras algún problema o deseas mejorar este proyecto, siéntete libre de abrir un problema o enviar un pull request.

## Licencia

Este proyecto está bajo la licencia [Apache2.0](LICENSE).
