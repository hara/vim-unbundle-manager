# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vim/unbundle/version'

Gem::Specification.new do |spec|
  spec.name          = "vim-unbundle-manager"
  spec.version       = Vim::Unbundle::VERSION
  spec.authors       = ["Yoshihiro Hara"]
  spec.email         = ["haraplusplus@gmail.com"]
  spec.description   = %q{vim-unbundle-manager is a manager to manage bundles for vim-unbundle.}
  spec.summary       = %q{A manager for vim-unbundle.}
  spec.homepage      = "https://github.com/hara/vim-unbundle-manager"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "git", "~> 1.2"
  spec.add_dependency "thor", "~> 0.18"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
end
