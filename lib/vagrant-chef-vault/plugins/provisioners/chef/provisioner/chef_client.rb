require 'pathname'

require 'vagrant'
require 'vagrant/util/presence'
require 'vagrant/util/subprocess'
require 'openssl'
require 'chef-api'

require Vagrant.source_root.join('plugins/provisioners/chef/provisioner/base')
require Vagrant.source_root.join('plugins/provisioners/chef/provisioner/chef_client')

module VagrantPlugins
  module Chef
    module Provisioner
      # This class implements provisioning via chef-client, allowing provisioning
      # with a chef server.
      class ChefClient < Base
        include Vagrant::Util::Presence
        def provision
          install_chef
          verify_binary(chef_binary_path('chef-client'))
          chown_provisioning_folder
          create_client_key_folder
          upload_validation_key
          upload_encrypted_data_bag_secret
          setup_json
          setup_server_config

          # Setup chef-api connection
          connection = ChefAPI::Connection.new(
            endpoint:   @config.chef_server_url,
            client:     @config.validation_client_name,
            key:         @config.validation_key_path,
            ssl_verify:  false
          )

          # Initialize connection
          connection.clients.fetch('chef-webui')

          # Create node object
          ChefAPI::Resource::Node.create(name: @config.node_name.to_s, chef_environment: @config.environment.to_s)

          # Generate client key pair
          rsa_key = OpenSSL::PKey::RSA.new(2048)
          private_key = rsa_key.to_pem
          public_key = rsa_key.public_key.to_pem

          # Send private key to client
          if windows?
            @machine.communicate.sudo("echo #{private_key} > C:\\chef\\client.pem")
          else
            @machine.communicate.sudo("echo \"#{private_key}\" | tee /etc/chef/client.pem")
          end

          # Create client object specifying previously generate public key
          ChefAPI::Resource::Client.create(name: 'chef-node2', public_key: public_key)

          puts "\r\nRunning knife vault refresh\r\n"
          result = Vagrant::Util::Subprocess.execute(
            'knife',
            'vault',
            'refresh',
            'chef_vault',
            "#{@config.environment.split('_')[1]}",
            '-M',
            'client',
            '--config',
            "#{File.dirname(@config.validation_key_path)}\\knife.rb",
            notify: %i[stdout stderr],
            workdir: 'C:\\Windows\\system32',
            env: { PATH: ENV['VAGRANT_OLD_ENV_PATH'] }
          ) do |io_name, data|
            @machine.env.ui.info "[#{io_name}] #{data}"
          end

          run_chef_client
          delete_encrypted_data_bag_secret
              end
      end
    end
  end
end
