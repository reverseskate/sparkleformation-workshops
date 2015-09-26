SparkleFormation.new(:example_elb).load(:base, :in_a_vpc).overrides do

  zones = registry!(:zones).map { |zone| zone.gsub('-','_') }
  subnets = registry!(:az_subnets, :public, :zones => zones)

  parameters(:load_balancer_name) do
    type 'String'
    description 'Load balancer name'
    default 'example-load-balancer'
  end

  ## Create the ELB Security Group. Open port 80 to the world.
  dynamic!(:security_group_with_rules, :example_elb,
           :ingress => {
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
           })

  ## Forward Port 80 to whatever is behind the ELB.
  resources(:example_elb) do
    type 'AWS::ElasticLoadBalancing::LoadBalancer'
    properties do
      load_balancer_name ref!(:load_balancer_name)
      security_groups [ ref!(:example_elb_security_group) ]
      subnets subnets
      listeners array!(
        -> {
          instance_port 80
          instance_protocol 'HTTP'
          load_balancer_port 80
          protocol 'HTTP'
        })
    end
  end

  ## Output ELB Info. We need the name and Security Group to add our
  ## ASG to the Load Balancer
  outputs do
    elb_dns do
      value attr!(:example_elb, 'DNSName')
    end
    
    elb_name do
      value ref!(:example_elb)
    end

    elb_sg do
      value ref!(:example_elb_security_group)
    end
  end
  
end
