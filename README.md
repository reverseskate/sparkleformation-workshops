## SparkleFormation Workshop Kit
This repository is a starter kit for Heavy Water's
SparkleFormation workshops. The content here provides a baseline for
workshop participants to immediately begin provisioning with
SparkleFormation and `sfn` to Amazon Web Services' Cloudformation.

## Requirements
You should have a modern Ruby version installed (>= 2.0.0 should work)
with Rubygems and the Bundler gem. Bundler manages the required gems.

## Instructions for Use

### Environment Variables
Export the following Environment Variables which are used to configure
the `sfn` CLI tool:

* `AWS_ACCESS_KEY_ID` An AWS IAM Access Key with adequate access
  rights to use CloudFormation (generally all except Billing).
* `AWS_SECRET_ACCESS_KEY` The Secret Key for the above IAM key ID.
* `AWS_REGION` The AWS region you wish to use for your provisioned resources.
* `NESTED_BUCKET` An existing S3 bucket which will store
  nested templates.
* `AWS_BUCKET_REGION` The AWS region where you created the template
  bucket, if it is not the same as `AWS_REGION`.
