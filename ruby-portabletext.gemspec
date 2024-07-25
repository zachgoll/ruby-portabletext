Gem::Specification.new do |spec|
  spec.name          = "ruby-portabletext"
  spec.version       = "0.1.0"
  spec.authors       = ["Zach Gollwitzer"]
  spec.email         = ["zach@linkslogicweb.com"]
  spec.summary       = "A Portable Text Renderer for Ruby"
  spec.files         = Dir["lib/**/*.rb", "test/**/*.rb"]
  spec.require_paths = ["lib"]
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.license       = "MIT"
  spec.homepage = "https://github.com/zachgoll/ruby-portabletext"
  spec.required_ruby_version = ">= 3.3.1"
end
