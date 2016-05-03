class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # deviseにカラムを追加し，DBに保存する場合に必要な記述
  before_action :configure_permitted_parameters, if: :devise_controller?
  def configure_permitted_parameters
      # sign_upにユーザネームを設定
      devise_parameter_sanitizer.for(:sign_up) { |u|
        u.permit(:email, :unique_name, :password, :password_confirmation)
      }
      devise_parameter_sanitizer.for(:sign_in) { |u|
        u.permit(:unique_name, :password, :remember_me)
    }
  end
end
