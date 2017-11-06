class Company
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  field :name,                        type: String, default: ""
  field :description,                 type: String, default: ""
  field :offer,                       type: String, default: ""
  field :cutoff,                      type: String, default: ""
  field :departments,                 type: String, default: ""
  field :columns,                     type: String, default: ""
  field :placement,                   type: Boolean
  field :intern,                      type: Boolean
  field :start_time,                  type: DateTime
  field :end_time,                    type: DateTime
  field :u_id,                        type: Integer

  after_save :add_fields_to_user
  validates_presence_of :name, :departments, :columns, :start_time, :end_time
  before_create :assign_uid
  has_many :registrations

  def assign_uid
    self.u_id = Company.last.u_id + 1
  end

  def add_fields_to_user
    new_fields = []
    array = self.columns.split(" ")
    fields = User.first.attributes.keys
    fields -= %w{_id encrypted_password sign_in_count roles_mask reset_password_token
           reset_password_sent_at remember_created_at sign_in_count u_id
           current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip}

    array.each do |c_field|
      new_fields << c_field unless fields.include? c_field
    end

    User.each do |user|
      new_fields.each do |field|
        user[field]=""
      end
      user.save
    end

  end
end
