# Awesome linter for FactotyBot

This gem enhances [FactoryBot linter](https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#linting-factories)

* it wraps factories creation:
  * within DatabaseCleaner if present
  * within ActiveRecord within transaction if DatabaseCleaner is not present but ActiveRecord is

* it displays a progress bar and quickly display failures (just like [fuubar](https://github.com/thekompanee/fuubar))
* it shows backtraces when factories failed
* it lints all factories and traits by default
* it allows easy selection of factories
* it reloads cached factories before each run

## Installation

Add these line to your application's Gemfile:

```ruby
gem 'factory_bot-awesome_linter'
```

## Usage

Just run:

```ruby
FactoryBot::AwesomeLinter.lint!
```

All factories are included by default.
You can select factories to lint by passing their names, a regexp, or factories:

```ruby
FactoryBot::AwesomeLinter.lint!(:user)
FactoryBot::AwesomeLinter.lint!(:user, :account)
FactoryBot::AwesomeLinter.lint!(/^new_/)

factories_to_lint = FactoryBot.factories.reject do |factory|
  factory.name =~ /^old_/
end

FactoryBot::AwesomeLinter.lint!(*factories_to_lint)
```

All traits are included by default.  
You can exclude them:

```ruby
FactoryBot::AwesomeLinter.lint!(traits: false)
```

Default linting strategy is `:create`.  
You can specify another strategy used for linting:

```ruby
FactoryBot::AwesomeLinter.lint!(strategy: :build)
```

All arguments can be combined:

```ruby
FactoryBot::AwesomeLinter.lint!(:user, strategy: :build, traits: false)
```

## Rake task

Create the following task in `lib/tasks/factory_bot.rake`

```ruby
namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task lint: :environment do
    if Rails.env.test?
      abort unless FactoryBot::AwesomeLinter.lint!
    else
      puts "Wrong environment detected to run factory_bot:lint"
      puts "Running `bundle exec bin/rails factory_bot:lint RAILS_ENV='test'` instead"

      system("bundle exec bin/rails factory_bot:lint RAILS_ENV='test'")
      exit $CHILD_STATUS.exitstatus
    end
  end
end
```

Then run :

```
bundle exec bin/rails factory_bot:lint RAILS_ENV='test'
```

## Contributing

1. Don't hesitate to submit your feature/idea/fix in [issues](https://github.com/inkstak/factory_bot-awesome_linter)
2. Fork the [repository](https://github.com/inkstak/factory_bot-awesome_linter)
3. Create your feature branch
4. Create a pull request
