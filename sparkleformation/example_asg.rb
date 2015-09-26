SparkleFormation.new(:example_asg).load(:base, :compute, :in_a_vpc).overrides do

  zones = registry!(:zones).map { |zone| zone.gsub('-','_') }
  subnets = registry!(:az_subnets, :public, :zones => zones)

  parameters do
    github_user do
      type 'String'
      description 'Github User for SSH'
    end

    hello_world do
      type 'String'
      description 'NGINX Hello World Text'
    end

    asg_size do
      type 'Number'
      description 'Fixed ASG Size'
      default 1
    end

    elb_name do
      type 'String'
      description 'ELB Name'
    end

    elb_sg do
      type 'String'
      descriptoon 'ELB Security Group'
    end
  end

  resources do
    example_asg do
      type 'AWS::AutoScaling::AutoScalingGroup'
      properties do
        load_balancer_names [ ref!(:elb_name) ]
        launch_configuration_name ref!(:example_launch_config)
        min_size ref!(:asg_size)
        max_size ref!(:asg_size)
        set!('VPCZoneIdentifier', subnets)
      end
      creation_policy do
        resource_signal do
          count 1
          timeout 'PT15M'
        end
      end
    end

    example_launch_config do
      type 'AWS::AutoScaling::LaunchConfiguration'
      properties do
        associate_public_ip_address true
        image_id 'ami-e5b8b4d5'
        instance_type 'm3.medium'
        security_groups [ ref!(:example_security_group) ]
        registry!(:init_and_signal_user_data, :example, :init_resource => :example_launch_config, :notify_resource => :example_asg)
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
               :ports => 80,
               :source_group => ref!(:elb_sg)
             }
           },
           :egress => {
             :all => {
               :protocol => '-1',
               :ports => [1, 65535]
             }
           }
           )

end
