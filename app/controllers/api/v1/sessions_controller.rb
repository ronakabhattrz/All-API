class Api::V1::SessionsController < Api::ApiController
	respond_to :json
	skip_before_action :verify_authenticity_token
	before_action :ensure_params_exist, only: [:create]

	def create 
    resource = User.find_for_database_authentication(email: params[:user][:email])
    return invalid_login_attempt unless resource
    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      render json: {status: "successful", user: { id: resource.id, email: resource.email, authentication_token: resource.authentication_token, created_at: resource.created_at, updated_at: resource.updated_at }}
      return
    end
    invalid_login_attempt
	end

	def destroy 
		if current_user.present?
		  sign_out(current_user)
		  render json: {status: "successful", message: "Your Account Logged Out Successfully" }
		else
		  render json: {status: "failed", message: "Authentication token is not valid" }
		end
	end

	protected

	def ensure_params_exist
	  return unless params[:user].blank?
	  render json: {status: "failed", message: "Missing User Parameter"}
	end

	def invalid_login_attempt
	  warden.custom_failure!
	  render json: {status: "failed", message: "Error with your Email or password"}
	end
end