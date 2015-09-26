SfnRegistry.register(:az_subnets) do |_name, _config = {}|

  ## _name will be the subnet prefix, e.g. "public"
  
  _config[:zones].map { |zone|  ref!([ _name, '_', zone, '_subnet' ].join.to_sym) }

end
