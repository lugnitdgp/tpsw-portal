module MyApp
  module Admin
    module Actions
      class FinalizeStudents < RailsAdmin::Config::Actions::Base

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-check'
        end

        register_instance_option :visible? do
          authorized? && bindings[:object].class == Company
        end

      end
    end
  end
end
