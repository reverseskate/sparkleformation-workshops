SparkleFormation.new(:example).load(:base).overrides do

  zone = registry!(:zones).first
  
  parameters do
    github_user do
      type 'String'
      description 'Github User for SSH'
    end

    
    vpc_id do
      type 'String'
      description 'VPC to Join'
    end

    set!(['public_', zone.gsub('-','_'), '_subnet'].join) do
      type 'String'
      description 'Subnet to join'
    end
  end
  
  resources do
    cfn_user do
      type 'AWS::IAM::User'
      properties do
        path '/'
        policies array!(
          -> {
            policy_name 'cfn_access'
            policy_document do
              statement array!(
                -> {
                  effect 'Allow'
                  action 'cloudformation:DescribeStackResource'
                  resource '*'
                }
              )
            end                 
          }
        )
      end
    end
    
    cfn_keys do
      type 'AWS::IAM::AccessKey'
      properties.user_name ref!(:cfn_user)
    end
    
    example_ec2_instance do
      type 'AWS::EC2::Instance'
      properties do
        availability_zone 'us-west-2a'
        image_id 'ami-e5b8b4d5'
        instance_type 'm3.medium'
        key_name 'michael-hw'
        network_interfaces array!(
          -> {
            associate_public_ip_address true
            device_index 0
            subnet_id ref!(['public_', zone.gsub('-','_'), '_subnet'].join.to_sym)
            group_set [ ref!(:example_security_group) ]
          }                          
        )
        user_data(
          base64!(
            join!(
              "#!/bin/bash\n",
              "apt-get update\n",
              "apt-get -y install python-setuptools\n",
              "easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz\n",
              '/usr/local/bin/cfn-init -v --region ',
              region!,
              ' -s ',
              stack_name!,
              " -r #{process_key!(:example_ec2_instance)} --access-key ",
              ref!(:cfn_keys),
              ' --secret-key ',
              attr!(:cfn_keys, :secret_access_key),
              "\n",
              "cfn-signal -e $? --region ",
              region!,
              ' --stack ',
              stack_name!,
              ' --resource ',
              process_key!(:example_ec2_instance),
              "\n"
            )
          )
        )
      end
      creation_policy do
        resource_signal do
          count 1
          timeout 'PT15M'
        end
      end
      metadata('AWS::CloudFormation::Init') do
        _camel_keys_set(:auto_disable)
        configSets do
          default [ 'github_ssh_user' ]
        end
        github_ssh_user do
          commands('00_apt_get_update') do
            command 'sudo apt-get update'
          end
          commands('01_install_curl') do
            command 'sudo apt-get install curl -y'
          end
          commands('02_set_ssh_keys') do
            command join!(
                      'sudo mkdir -p /home/ubuntu/.ssh && sudo curl https://github.com/',
                      ref!(:github_user),
                      '.keys >> /home/ubuntu/.ssh/authorized_keys'
                    )
          end
        end 
      end
    end

    example_security_group do
      type 'AWS::EC2::SecurityGroup'
      properties do
        group_description "Security Group for Example"
        vpc_id ref!(:vpc_id)
      end
    end
    
    example_ssh_security_group_ingress do
      type 'AWS::EC2::SecurityGroupIngress'
      properties do
        group_id ref!(:example_security_group)
        ip_protocol 'tcp'
        from_port 22
        to_port 22
        cidr_ip '0.0.0.0/0'
      end
    end

    example_http_security_group_ingress do
      type 'AWS::EC2::SecurityGroupIngress'
      properties do
        group_id ref!(:example_security_group)
        ip_protocol 'tcp'
        from_port 80
        to_port 80
        cidr_ip '0.0.0.0/0'
      end
    end

    example_all_security_group_egress do
      type 'AWS::EC2::SecurityGroupEgress'
      properties do
        group_id ref!(:example_security_group)
        ip_protocol '-1'
        from_port 1
        to_port 65535
        cidr_ip '0.0.0.0/0'
      end
    end
  end

  outputs do
    ec2_ip_address do
      value attr!(:example_ec2_instance, :public_ip)
    end
  end
end
