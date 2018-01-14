require Rails.root.join('lib', 'rails_admin', 'finalize_students.rb')
require Rails.root.join('lib', 'rails_admin', 'dashboard.rb')
RailsAdmin::Config::Actions.register(MyApp::Admin::Actions::FinalizeStudents)

RailsAdmin.config do |config|

  config.model Company do
    list do
      exclude_fields :_id
      fields :c_at do
        label "Created At"
      end
    end
    edit do
      exclude_fields :c_at, :u_id, :registrations, :fte_offers, :intern_offers
      field :columns do
        partial 'columns'
      end
      field :departments do
        partial 'departments'
      end
      field :company_type do
        partial 'company_type'
      end
    end
  end

 config.model User do
   list do
     exclude_fields :_id
     fields :c_at do
       label "Created At"
     end
   end
 end

 config.excluded_models << "Registration"
  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    finalize_students
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
