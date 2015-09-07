SparkleFormation.dynamic(:subnet) do |_name, _config = {}|

  parameters("#{_name}_subnet_cidr".to_sym) do
    type 'String'
  end

  resources("#{_name}_subnet".to_sym) do
    type 'AWS::EC2::Subnet'
    properties do
      vpc_id _config[:vpc_id]
      cidr_block ref!("#{_name}_subnet_cidr".to_sym)
      availability_zone _config[:availability_zone]
      tags _array(
        -> {
          key 'Name'
          value join!(ref!('AWS::StackName'), " #{_name}")
        }
      )
    end
  end

  resources("#{_name}_subnet_route_table_association".to_sym) do
    type 'AWS::EC2::SubnetRouteTableAssociation'
    properties do
      route_table_id _config[:route_table]
      subnet_id ref!("#{_name}_subnet".to_sym)
    end
  end

  outputs("#{_name}_subnet".to_sym) do
    value ref!("#{_name}_subnet".to_sym)
  end

end
