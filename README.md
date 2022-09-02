# ITC - AWS Account Base Configuration

![CI workflow](https://github.com/indigo-tangerine/itc-aws-base-cfg/actions/workflows/ci-pr.yml/badge.svg)
![CD workflow](https://github.com/indigo-tangerine/itc-aws-base-cfg/actions/workflows/cd.yml/badge.svg)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/indigo-tangerine/itc-aws-base-cfg)

## Resources

* Encrypted, versioned, S3 bucket for terraform state files
* Encrypted DynamoDb table for terraform state locks
* IAM user for ci/cd automation & IAM policy
* IAM role for ci/cd automation
  * Can be assumed by ci/cd user and github oidc role
* GitHub OIDC identity provider
* IAM role for ci/cd automation that can be assumed by GitHub OIDC IdP
* Cloudtrail log bucket
