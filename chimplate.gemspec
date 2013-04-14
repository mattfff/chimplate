$:.push File.expand_path("../lib", __FILE__)
require "chimplate/version"

Gem::Specification.new do |s|
  s.name        = 'chimplate'
  s.version     = Chimplate::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2013-04-13'
  s.summary     = "Chimplate"
  s.description = "A small command line utility to ease local editing and version control of mailchimp user templates."
  s.authors     = ["Matt White"]
  s.email       = 'matt@bitforge.us'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.homepage      = 'http://bitforge.us'
  s.require_paths = ["lib"]
  s.add_dependency "mailchimp"
  s.add_dependency "json"
  s.add_dependency "thor"
  s.add_dependency "listen"
end
