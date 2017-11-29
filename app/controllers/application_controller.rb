class ApplicationController < ActionController::Base
  include Navigation
  before_action :authorize, :set_navigations
  protect_from_forgery with: :exception
  
  protected
    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: 'Please Login'
      end
    end
end
