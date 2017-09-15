class Registration
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  field :type,                        type: String, default: ""
  belongs_to :user
  belongs_to :company
end
