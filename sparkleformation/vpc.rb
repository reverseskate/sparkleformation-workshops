SparkleFormation.new(:hw_training_vpc).load(:base, :vpc).overrides do

  description 'Basic VPC for Heavy Water SparkleFormation Workshop'
  
  dynamic!(:subnet, ['public_', zone.gsub('-', '_') ].join,
           :vpc_id => ref!(:vpc),
           :route_table => ref!(:public_route_table),
           :availability_zone => zone
           )
  end

end
