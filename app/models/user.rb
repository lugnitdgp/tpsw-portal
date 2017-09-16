class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps::Created::Short

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,                 type: String, default: ""
  field :name,                  type: String, default: ""
  field :roll_no,               type: String, default: ""
  field :cgpa,                  type: String, default: ""
  field :present_address,       type: String, default: ""
  field :permanent_address,     type: String, default: ""
  field :sgpa,                  type: Array,  default: []
  field :dept,                  type: String, default: ""
  field :phone,                 type: String, default: ""
  field :pan_no,                type: String, default: ""
  field :placed_at,             type: String, default: ""
  field :ug_pg,                 type: String, default: ""

  field :u_id,                  type: Integer, default: ""
  field :encrypted_password,    type: String, default: ""
  field :roles_mask,            type: Integer,default: ""
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  # validates :uid, uniqueness: true
  before_create :assign_uid_and_new_fields
  before_save :enforce_standard
  has_many :registrations
  validates_uniqueness_of :roll_no

  def assign_uid_and_new_fields
    self.u_id = User.last.u_id + 1
    new_fields = User.last.attributes.keys
    new_fields -= %w{_id encrypted_password sign_in_count roles_mask reset_password_token
           reset_password_sent_at remember_created_at sign_in_count u_id
           current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip}
    new_fields -= User.first.fields.keys
    new_fields.each do |field|
      self[field]=""
    end
  end

  def enforce_standard
    self.name = self.name.split.map(&:capitalize).join(' ')
  end

end
