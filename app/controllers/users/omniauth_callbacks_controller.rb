class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate

  def doorauth
    # state = request.params["state"]
    # session[:return_to] = state['return_to'] if state['return_to']

    # @user = User.from_omniauth(auth)

    # if @user.nil?
    #   flash[:error] = "Login failed!"
    #   return redirect_to root_path(sign_out: true)
    # end

    # cookies.encrypted[:user_id] = @user.id
    debugger

    # sign_in_and_redirect @user, event: :authentication
    redirect_to home_path
  end

  def after_sign_in_path_for(resource)
    # path = session[:return_to] || home_path
    # session.delete(:return_to)
    # path
  end

  def failure
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end