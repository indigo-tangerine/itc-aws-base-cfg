# Terraform backend file in S3
# key = "repository_name/client/stage/service_group.tfstate"
key = "itc-aws-base-cfg/main.tfstate"

# service-group: main, feature/gmp-345, ...
# s3 structure:
# |_ client
# |  |_ tst
# |  |   |_ main.tfstate
# |  |   |_ ...
# |  |_ acc
# |  |_ prd
# |_ team
#    |_ dev
#        |_ main.tfstate
#        |_ feature-LANZ-8476.tfstate
#        |_ bugfix-GMP-746.tfstate
#        |_ ...
