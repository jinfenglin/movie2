# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "Movie2"
  spec.version       = '1.0'
  spec.authors       = ["JinfengLin"]
  spec.email         = ["ljf1992@brandeis.edu"]
  spec.summary       = %q{Short summary of your project}
  spec.description   = %q{Longer description of your project.}
  spec.homepage      = "http://domainforproject.com/"
  spec.license       = "MIT"

  spec.files         = ['lib/movie2.rb']
  spec.executables   = ['bin/movie2']
  spec.test_files    = ['tests/test_movie2.rb']
  spec.require_paths = ["lib"]
end