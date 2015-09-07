SparkleFormation.new(:coolapp_vpc).load(:base, :vpc).overrides do

zones = registry!(:zones)

  zones.each do |zone|
  
  dynamic!(:subnet, ['public_', zone.gsub('-', '_') ].join,
           :vpc_id => ref!(:vpc),
           :route_table => ref!(:public_route_table),
           :availability_zone => zone
           )
  end

end
