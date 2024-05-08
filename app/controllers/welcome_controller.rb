class WelcomeController < ApplicationController
  skip_before_action :authenticate

  def index
    if params[:sign_out]
      error = flash[:error]
      sign_out current_user if user_signed_in?
      reset_session
      flash.now[:error] = error
    end
    session[:return_to] = params[:return_to] if params[:return_to]

    return unless user_signed_in?

    redirect_to home_path
  end
end
