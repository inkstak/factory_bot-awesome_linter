# frozen_string_literal: true

require 'factory_bot'
require 'ruby-progressbar'

module FactoryBot
  class AwesomeLinter
    def self.lint!(*args, **kwargs)
      new(*args, **kwargs).lint!
    end

    def initialize(*args, strategy: :create, traits: false)
      @factories_to_lint = load_factories(*args)

      @factory_strategy  = strategy
      @traits            = traits
      @progress_bar      = ProgressBar.create(format: "\e[0;32m %c/%C |%w>%i| %e \e[0m")
      @invalid_factories = []
    end

    attr_reader :progress_bar, :factories_to_lint, :invalid_factories

    def lint!
      progress_bar.total = calculate_total

      factories_to_lint.each do |factory|
        lint_factory(factory)
        progress_bar.increment

        next unless @traits

        factory.definition.defined_traits.each do |trait|
          lint_trait(factory, trait)
          progress_bar.increment
        end
      end

      progress_bar.stop

      output_invalid_factories
      invalid_factories.empty?
    end

    def load_factories(*args)
      FactoryBot.reload
      return FactoryBot.factories if args.empty?

      args.flat_map do |arg|
        case arg
        when Symbol, String
          FactoryBot.factories.find(arg)
        when Regexp
          FactoryBot.factories.select { |factory| factory.name.match?(arg) }
        when FactoryBot::Factory
          arg
        else
          raise TypeError, "unexpected argument: #{arg}"
        end
      end
    end

    def calculate_total
      factories_to_lint.reduce(0) do |count, factory|
        if @traits
          # Compile factory to count enum traits
          factory.compile
          count + 1 + factory.definition.defined_traits.size
        else
          count + 1
        end
      end
    end

    def lint_factory(factory)
      cleaning do
        FactoryBot.public_send(@factory_strategy, factory.name)
      end
    rescue StandardError => e
      invalid_factory! e, factory
    end

    def lint_trait(factory, trait)
      cleaning do
        FactoryBot.public_send(@factory_strategy, factory.name, trait.name)
      end
    rescue StandardError => e
      invalid_factory! e, factory
    end

    def invalid_factory!(error, factory, trait = nil)
      name = ":#{factory.name}"
      name += " + :#{trait.name}" if trait

      invalid_factories << name

      progress_bar.format = "\e[0;31m %c/%C |%w>%i| %e \e[0m"

      progress_bar.log "\n  - Invalid factory: #{name}"
      progress_bar.log "\n    \e[0;31m#{error.message}\e[0m"

      error.backtrace[0..10].each do |s|
        progress_bar.log "    \e[0;36m# #{s}\e[0m"
      end

      progress_bar.log "\n"
    end

    def output_invalid_factories
      return if invalid_factories.empty?

      $stdout.puts "\nInvalid factories:"

      invalid_factories.each do |name|
        $stdout.puts "  \e[0;31m- #{name}\e[0m"
      end

      $stdout.puts
    end

    def cleaning(&block)
      if defined?(DatabaseCleaner)
        DatabaseCleaner.cleaning(&block)
      elsif defined?(ActiveRecord)
        @activerecord_connection ||= ActiveRecord::Base.connection
        @activerecord_connection.transaction(&block)
      else
        raise "No cleaning strategie available, you may require or include database-cleaner in your Gemfile"
      end
    end
  end
end
