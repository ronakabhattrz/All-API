class Api::V1::RegistrationsController < Api::ApiController
	respond_to :json
	skip_before_action :verify_authenticity_token
	before_action :check_user, only: [:create]

  def create
    if params[:user][:email].blank? || params[:user][:password].blank? || params[:user][:password_confirmation].blank?
      render json: {status: "failed", message: "Missing parameters"}
    else
			@user = User.new(user_params)
			@user.generate_auth_token!
			if @user.save
			  render json: {status: "successful", user: { id: @user.id, email: @user.email, authentication_token: @user.authentication_token, created_at: @user.created_at, updated_at: @user.updated_at }}
			else 
			  render json: {status: "failed", user: @user.errors}
			end
    end
  end

  private 

  def user_params
    params.require(:user).permit(:email,:password,:password_confirmation)
  end

  def check_user
    if User.exists?(email: params[:user][:email])
      render  json: {status: "failed", message: "User already exists"}
    end
  end
end