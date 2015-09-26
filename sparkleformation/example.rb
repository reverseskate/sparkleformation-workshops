SparkleFormation.new(:example).load(:base, :compute, :in_a_vpc).overrides do

  zone = registry!(:zones).first
  
  parameters do
    github_user do
      type 'String'
      description 'Github User for SSH'
    end

    hello_world do
      type 'String'
      description 'NGINX Hello World Text'
    end
  end

  resources do
    example_ec2_instance do
      type 'AWS::EC2::Instance'
      properties do
        availability_zone zone
        image_id 'ami-e5b8b4d5'
        instance_type 'm3.medium'
        network_interfaces array!(
          -> {
            associate_public_ip_address true
            device_index 0
            subnet_id ref!(['public_', zone.gsub('-','_'), '_subnet'].join.to_sym)
            group_set [ ref!(:example_security_group) ]
          }                          
        )
        registry!(:init_and_signal_user_data, :example, :init_resource => :example_ec2_instance, :notify_resource => :example_ec2_instance)
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
          default [ ]
        end
      end
      registry!(:github_ssh_user)
      registry!(:nginx_hello_world)
    end
  end

  dynamic!(:security_group_with_rules, :example,
           :ingress => {
             :ssh => {
               :protocol => 'tcp',
               :ports => 22
             },
             :http => {
               :protocol => 'tcp',
               :ports => 80
             }
           },
           :egress => {
             :all => {
               :protocol => '-1',
               :ports => [1, 65535]
             }
           }
           )

  outputs do
    ec2_ip_address do
      value attr!(:example_ec2_instance, :public_ip)
    end
    ec2_dns_address do
      value attr!(:example_ec2_instance, :public_dns_name)
    end
  end
end
