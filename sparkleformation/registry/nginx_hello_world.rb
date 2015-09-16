SfnRegistry.register(:nginx_hello_world) do
  metadata('AWS::CloudFormation::Init') do
    _camel_keys_set(:auto_disable)
    configSets do |sets|
      sets.default += ['nginx_hello_world']
    end
    nginx_hello_world do
      packages(:apt) do
        nginx ''
      end
      files('/usr/share/nginx/html/index.html') do
        content join!(
                  '<html>',
                  ref!(:hello_world),
                  '</html>'
                )
      end
      services(:sysvinit) do
        nginx do
          enabled true
          ensureRunning true
          sources ['/usr/share/nginx/html/index.html']
        end
      end
    end
  end
end
