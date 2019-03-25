require 'vagrant'

module VagrantPlugins
  module VagrantChefVault
    class Plugin < Vagrant.plugin('2')
      name 'chefvault'
      description <<-DESC
      Plugin created by Red gate to quickly monkey patch vagrant.
      DESC
    end
  end
end

# This is the first file that gets loaded, so we need to specify which files in this gem should be loaded.
require 'vagrant-chef-vault/plugins/provisioners/chef/provisioner/chef_client'
