class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :discord

  def discord
    @user = User.find_or_create_from_auth_hash!(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in @user
      set_flash_message(:notice, :success, kind: 'Discord') if is_navigational_format?
      redirect_to items_path
    else
      session['devise.discord_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end
end
