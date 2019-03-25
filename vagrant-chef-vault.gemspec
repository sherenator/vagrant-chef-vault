
lib = File.expand_path(__dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-chef-vault'
  spec.version       = 1
  spec.authors       = ['Greg Sher']
  spec.email         = ['greg.sher@altsrc.net']
  spec.description   = 'Insert chef-vault operations into Vagrant chef-client bootstrap process'
  spec.summary       = spec.description
  spec.homepage      = 'http://altsrc.net'

  spec.bindir = 'bin'
  spec.executables = %w[]

  spec.require_path = 'lib'
  spec.files = %w[Gemfile Rakefile] +
               Dir.glob('*.gemspec') +
               Dir.glob('{distro,lib,tasks,spec}/**/*',
                        File::FNM_DOTMATCH).reject { |f| File.directory?(f) }

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'chef-api'
  spec.add_development_dependency 'memfs'
  spec.add_runtime_dependency 'chef-api'
  spec.add_development_dependency 'pry'
  spec.add_runtime_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_runtime_dependency 'memfs'
  spec.add_runtime_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
end
