$:.push File.expand_path('lib', __dir__)
require 'factory_bot-awesome_linter/version'

Gem::Specification.new do |s|
  s.name          = 'factory_bot-awesome_linter'
  s.version       = FactoryBot::AwesomeLinter::VERSION
  s.authors       = ['Savater Sebastien']
  s.email         = ['savater.sebastien@gmail.com']
  s.homepage      = 'https://github.com/inkstak/factory_bot-awesome_linter'
  s.licenses      = ['MIT']
  s.summary       = 'Enhanced linter for FactoryBot'

  s.files         = Dir['lib/**/*']
  s.require_paths = ['lib']

  s.add_dependency 'factory_bot',      '>= 6.1.0'
  s.add_dependency 'ruby-progressbar', '>= 1.11.0'
end
