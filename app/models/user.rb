class User < ActiveRecord::Base  
  devise :database_authenticatable, :registerable,
     :recoverable, :rememberable, :trackable, :validatable

  # Authorization token for api sessions
  before_create :generate_auth_token!
  
  validates :password, length: { minimum: 8 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, presence: true, uniqueness: true

  # Function used to generate token for api authentication
  def generate_auth_token!
		begin
		  self.authentication_token = Devise.friendly_token
		end while self.class.exists?(authentication_token: authentication_token)
   end
end