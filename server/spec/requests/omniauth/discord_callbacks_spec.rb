# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OmniAuth Discord コールバック', type: :request do
  let(:uid) { '1234567890' }

  # この around ブロックでは、OmniAuth/ENV/外部HTTPスタブをテスト中だけ有効にし、
  # 例外が出ても必ず元の環境変数に戻す。
  around do |example|
    OmniAuth.config.test_mode = true
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]

    # 元の環境変数を退避（nil の可能性も含めてそのまま復元できるようにする）
    original_next = ENV['NEXT_APP_URL']
    original_server = ENV['DISCORD_SERVER_ID']
    original_bot = ENV['DISCORD_BOT_TOKEN']

    # テスト用のダミーURL/トークン/サーバIDを設定
    ENV['NEXT_APP_URL'] = 'https://example.com'
    ENV['DISCORD_SERVER_ID'] = 'guild_1'
    ENV['DISCORD_BOT_TOKEN'] = 'dummy_token'

    # Discord から返ってくる認可情報（auth_hash）をモック
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(
      provider: 'discord',
      uid:,
      info: { name: 'alice' },
      extra: { raw_info: { avatar: nil } }
    )

    # サーバーメンバー確認の外部HTTPをスタブ（200で通過させる）
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{uid}")
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    example.run
  ensure
    # 必ず元の環境変数に戻す（テスト汚染を避ける）
    ENV['NEXT_APP_URL'] = original_next
    ENV['DISCORD_SERVER_ID'] = original_server
    ENV['DISCORD_BOT_TOKEN'] = original_bot
  end

  it 'ログインに成功し、NEXT_APP_URL のコールバックに 302 でリダイレクトする' do
    # OmniAuth のコールバックエンドポイントを叩く（成功パス想定）
    get user_discord_omniauth_callback_path

    expect(response).to have_http_status(:found)
    # 成功後は Next の固定コールバックURLへリダイレクト
    expect(response).to redirect_to('https://example.com/auth/callback')

    # コールバック内部でユーザーが作成されていることを確認
    user = User.find_by(provider: 'discord', uid:)
    expect(user).to be_present
  end
end
