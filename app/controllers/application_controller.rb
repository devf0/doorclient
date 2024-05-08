class ApplicationController < ActionController::Base
  before_action :test
  before_action :authenticate

  private

  def test
    # session["warden.user.user.key"] = [[1], ""]
    # session["_csrf_token"] = "IlustGyk5HghVfVPvCg3hDz7gAk9H05Wuy6ex32RoE4"
  end

  def authenticate
    debugger
    unless user_signed_in?
      session[:return_to] = request.url
      redirect_to root_path
      return
    end
  end
end
