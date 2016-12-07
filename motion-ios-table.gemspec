# -*- encoding: utf-8 -*-
VERSION = "1.0"

Gem::Specification.new do |spec|
  spec.name          = "motion-ios-table"
  spec.version       = VERSION
  spec.authors       = ["Mark Villacampa"]
  spec.email         = ["m@markvillacampa.com"]
  spec.description   = "Easily configure iOS table views using a hash."
  spec.summary       = "Easily configure iOS table views using a hash."
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "motion-stump"
end
