SparkleFormation.new(:hello_world_all_in_one) do
  nest!(:hw_training_vpc)
  nest!(:example_elb)
  nest!(:example_asg)
end
  
