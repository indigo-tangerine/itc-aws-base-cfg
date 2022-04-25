# Terraform variables
stage           = "xxx"
client          = "itc"
service_version = "<service-version>"
service_group   = "main"
service         = "aws-base-cfg"
aws_account_id  = "256645035107"
github_org      = "indigo-tangerine"

# Do not change "<service-version>" - this will be replaced during deployment with the correct value

# service-group: main, feature/gmp-345, ...
# s3 structure:
# |_ client
# |  |_ tst
# |  |   |_ main.tfstate
# |  |   |_ ...
# |  |_ acc
# |  |_ prd
# |_ ohp
# |  |_ int
# |      |_ main.tfstate
# |_ team
#    |_ dev
#        |_ main.tfstate
#        |_ feature-LANZ-8476.tfstate
#        |_ bugfix-GMP-746.tfstate
#        |_ ...
#
#
