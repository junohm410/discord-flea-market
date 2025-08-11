# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :discord

  def discord
    @user = User.find_or_create_from_auth_hash!(request.env['omniauth.auth'])

    if @user.persisted?
      app_url = resolve_next_app_url
      return render(plain: 'NEXT_APP_URL is not configured', status: :internal_server_error) unless app_url

      # 常に固定のコールバックページへリダイレクト
      sign_in @user
      redirect_to URI.join(app_url, '/auth/callback').to_s, allow_other_host: true
    else
      session['devise.discord_data'] = request.env['omniauth.auth'].except('extra')
      app_url = resolve_next_app_url
      return render(plain: 'NEXT_APP_URL is not configured', status: :internal_server_error) unless app_url

      redirect_to URI.join(app_url, '/auth/callback?error=login_failed').to_s, allow_other_host: true
    end
  end

  def failure
    app_url = resolve_next_app_url
    return render(plain: 'NEXT_APP_URL is not configured', status: :internal_server_error) unless app_url

    redirect_to URI.join(app_url, '/auth/callback?error=oauth_failure').to_s, allow_other_host: true
  end

  private

  def resolve_next_app_url
    env_url = ENV['NEXT_APP_URL']
    return env_url if env_url.present?

    return 'http://localhost:3000' if Rails.env.development?

    nil
  end
end
