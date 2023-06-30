# frozen_string_literal: true

module FactoryBot
  module Generators
    module AwesomeLinter
      class InstallGenerator < Rails::Generators::Base
        desc "Create a task to lint FactoryBot factories"
        source_root File.expand_path("templates", __dir__)

        # copy rake tasks
        def copy_tasks
          template "factory_bot.rake", "lib/tasks/factory_bot.rake"
        end
      end
    end
  end
end