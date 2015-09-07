## SparkleFormation Workshop Kit
This repository is a starter kit for Heavy Water's
SparkleFormation workshops. The content here provides a baseline for
workshop participants to immediately begin provisioning with
SparkleFormation and `sfn` to Amazon Web Services' CloudFormation.

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

### Installation
Install the required gems using Bundler by running `bundle
install`. Post installation, you should see the following:
```
This is an install of the sfn gem from the 1.0 release tree. If you
are upgrading from a pre-1.0 version, please review the CHANGELOG and
test your environment _before_ continuing on!

* https://github.com/sparkleformation/sfn/blob/master/CHANGELOG.md

Happy stacking!
```
Following installation, you may run `bundle exec sfn list` to check your
installation. If you have already provisioned CloudFormation stacks in
the configured region, you should see a list of those stacks. If you
do not have CloudFormation stacks provisioned, you should see the
following:
```
Name                   Created                StatusTemplate                Description
```

