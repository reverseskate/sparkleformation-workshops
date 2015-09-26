SparkleFormation.dynamic(:security_group_with_rules) do |_name, _config = {}|

  ## Usage:
  ##
  ## Security Group rules are defined via 'ingress' and 'egress'
  ## hashes of named rules passed in the _config argument. Each rule
  ## supports the following keys:
  ##
  ## :protocol (required) - the protocol ('tcp', 'udp', '-1')
  ## :ports (required) - an array of 1 or 2 port numbers. If specifying
  ##   a range, the lower port must be first.
  ## :source_group/:destination_group (optional) - a Security Group to
  ##   grant ingress (source) or egress (destination) access to. If not
  ##   specified, assumes a CIDR block.
  ## :cidr_ip (optional) - The CIDR block the rule applies to. If
  ##   neither a source/destination group nor a CIDR block is passed,
  ##   defaults to allow all (0.0.0.0/0).
  
  
  rules = _config.fetch(:rules, {})

  resources do

    set!("#{_name}_security_group") do
      type 'AWS::EC2::SecurityGroup'
      properties do
        group_description "Security Group for #{_name}"
        vpc_id _config.fetch(:vpc_id, ref!(:vpc_id))
      end
    end

    if _config[:ingress]

      _config[:ingress].each do |rule, settings|

        ports = [ settings[:ports] ].flatten

        set!("#{_name}_#{rule}_security_group_ingress") do
          type 'AWS::EC2::SecurityGroupIngress'
          properties do
            group_id ref!("#{_name}_security_group".to_sym)
            ip_protocol settings[:protocol]
            from_port ports.first
            to_port ports.last
            if settings[:source_group]
              source_security_group_id settings[:source_group]
            else
              cidr_ip settings.fetch(:cidr_ip, '0.0.0.0/0')
            end
          end
        end
      end
    end

    if _config[:egress]

      _config[:egress].each do |rule, settings|

        ports = [ settings[:ports] ].flatten

        set!("#{_name}_#{rule}_security_group_egress") do
          type 'AWS::EC2::SecurityGroupEgress'
          properties do
            group_id ref!("#{_name}_security_group".to_sym)
            ip_protocol settings[:protocol]
            from_port ports.first
            to_port ports.last
            if settings[:destination_group]
              destination_security_group_id settings[:destination_group]
            else
              cidr_ip settings.fetch(:cidr_ip, '0.0.0.0/0')
            end
          end
        end
      end
    end
  end

end
