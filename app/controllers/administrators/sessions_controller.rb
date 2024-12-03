class Administrators::SessionsController < ApplicationController
  layout 'application'

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = login(admin_session_params[:email], admin_session_params[:password], admin_session_params[:remember])

    if @admin_user
      redirect_back_or_to('/admin', notice: 'Login successful')
    else
      @admin_user = AdminUser.new(email: admin_session_params[:email])
      flash.now[:alert] = 'Login failed'
      render action: :new
    end
  end

  def sign_out
    logout
    redirect_to('/admin', notice: 'Logged out!')
  end

  private

  # Only allow a trusted parameter "white list" through.
  def admin_session_params
    params.require(:admin_user).permit(:email, :password, :remember)
  end
end
