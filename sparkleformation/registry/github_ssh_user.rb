SfnRegistry.register(:github_ssh_user) do
  metadata('AWS::CloudFormation::Init') do
    _camel_keys_set(:auto_disable)
    configSets do |sets|
      sets.default += ['github_ssh_user']
    end
    github_ssh_user do
      commands('00_apt_get_update') do
        command 'sudo apt-get update'
      end
      commands('01_install_curl') do
        command 'sudo apt-get install curl -y'
      end
      commands('02_set_ssh_keys') do
        command join!(
                  'sudo mkdir -p /home/ubuntu/.ssh && sudo curl https://github.com/',
                  ref!(:github_user),
                  '.keys >> /home/ubuntu/.ssh/authorized_keys'
                )
      end
    end 
  end
end
