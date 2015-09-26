SparkleFormation.component(:compute) do

  ## Creates IAM user that can access compute resource metadata.
  resources do
    cfn_user do
      type 'AWS::IAM::User'
      properties do
        path '/'
        policies array!(
          -> {
            policy_name 'cfn_access'
            policy_document do
              statement array!(
                -> {
                  effect 'Allow'
                  action 'cloudformation:DescribeStackResource'
                  resource '*'
                }
              )
            end                 
          }
        )
      end
    end
    
    cfn_keys do
      type 'AWS::IAM::AccessKey'
      properties.user_name ref!(:cfn_user)
    end

  end
end

