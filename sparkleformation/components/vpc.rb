SparkleFormation.component(:vpc) do

  parameters(:vpc_cidr) do
    description 'VPC Subnet'
    type 'String'
    default '10.0.0.0/16'
  end

  parameters(:dns_support) do
    description 'Enable VPC DNS Support'
    type 'String'
    default 'true'
    allowed_values %w(true false)
  end

  parameters(:dns_hostnames) do
    description 'Enable VPC DNS Hostname Support'
    type 'String'
    default 'true'
    allowed_values %w(true false)
  end

  parameters(:instance_tenancy) do
    description 'Enable VPC Instance Tenancy'
    type 'String'
    default 'default'
    allowed_values %w(default dedicated)
  end

  resources(:dhcp_options) do
    type 'AWS::EC2::DHCPOptions'
    properties do
      domain_name 'ec2.internal'
      domain_name_servers ['AmazonProvidedDNS']
      tags _array(
        -> {
          key 'Name'
          value stack_name!
        }
      )
    end
  end

  resources(:vpc) do
    type 'AWS::EC2::VPC'
    properties do
      cidr_block ref!(:vpc_cidr)
      enable_dns_support ref!(:dns_support)
      enable_dns_hostnames ref!(:dns_hostnames)
      instance_tenancy ref!(:instance_tenancy)
      tags _array(
        -> {
          key 'Name'
          value stack_name!
        }
      )
    end
  end

  resources(:vpc_dhcp_options_association) do
    type 'AWS::EC2::VPCDHCPOptionsAssociation'
    properties do
      vpc_id ref!(:vpc)
      dhcp_options_id ref!(:dhcp_options)
    end
  end

  %w( public private ).each do |type|
    resources("#{type}_route_table".to_sym) do
      type 'AWS::EC2::RouteTable'
      properties do
        vpc_id ref!(:vpc)
        tags _array(
          -> {
            key 'Name'
            value join!(stack_name!, " #{type}")
          }
        )
      end
    end
  end

  resources(:internet_gateway) do
    type 'AWS::EC2::InternetGateway'
    properties do
      tags _array(
        -> {
          key 'Name'
          value stack_name!
        }
      )
    end
  end

  resources(:internet_gateway_attachment) do
    type 'AWS::EC2::VPCGatewayAttachment'
    properties do
      internet_gateway_id ref!(:internet_gateway)
      vpc_id ref!(:vpc)
    end
  end

  resources(:public_subnet_internet_route) do
    type 'AWS::EC2::Route'
    properties do
      destination_cidr_block '0.0.0.0/0'
      gateway_id ref!(:internet_gateway)
      route_table_id ref!(:public_route_table)
    end
  end

  outputs(:vpc_id) do
    value ref!(:vpc)
  end

  [ :vpc_cidr, :public_route_table, :private_route_table, :internet_gateway ].each do |x|
    outputs do
      set!(x) do
        value ref!(x)
      end
    end
  end

end
