# vagrant-chef-vault

`vagrant-chef-vault` is a plugin for Vagrant which facilitates integration with chef-vault

By installing this plugin and requiring it in your Vagrantfile, the standard Vagrant chef-client provisioner will be patched such that nodes are granted vault access at build time.

`knife.rb` path is currently inferred from `validation_key_path`, although this should probably be updated to allow passing a separate path if needed.

The chef-vault to which access is granted will be derived from the chef environment of the node being built. For example, a node with environment 'chicago_development' would be granted access to the vault 'development' (environment string is split on the underscore). 
