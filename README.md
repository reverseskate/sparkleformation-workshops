## SparkleFormation Workshop Kit
This repository is a starter kit for Heavy Water's
SparkleFormation workshops. The content here provides a baseline for
workshop participants to immediately begin provisioning with
SparkleFormation and `sfn` to Amazon Web Services' CloudFormation.

## Requirements
You should have a modern Ruby version installed (>= 2.0.0 should work)
with Rubygems and the Bundler gem. Bundler manages the required gems.

You should also bookmark or otherwise make note of the [AWS
CloudFormation Reference Docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html).
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
### Provision a Basic VPC
This repository includes a SparkleFormation template to create a basic
VPC for training purposes. You should be able to provision this VPC
"out-of-the-box" by issuing the following create command:
```
bundle exec sfn create training-vpc --file sparkleformation/vpc.rb
```
Sfn will prompt for a number of parameters. There should be a default
for each parameter, indicated by brackets, which you can accept.

Note that 'training-vpc' is the stack name, and you may change this to
a name of your choosing. Stack names are restricted to alphanumeric
characters and the '-'. They must begin with a letter.

The training VPC creates the following resources:
* A VPC in the specified region with the specified VPC subnet CIDR
(defaults to 10.0.0.0/16).
* An Internet Gateway to route public traffic to the Internet.
* Public and Private Route Tables (the private route table is unused
initially).
* A Public Subnet in each Availability Zones available to your
account. A registry entry queries AWS to determine the available AZs
in this example.

Upon stack completion, Sfn will print the stack outputs, which include
the resource ids for the above provisioned resources.

**You Are Now Ready for the Workshop!**
