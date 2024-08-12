# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:uid) { '1234567' }

  before do
    OmniAuth.config.test_mode = true
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    OmniAuth.config.mock_auth[:discord] = discord_mock
  end

  it 'can sign in' do
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{uid}")

    visit root_path
    click_on 'Discordでログイン'
    expect(page).to have_content 'Discord アカウントによる認証に成功しました。'
    expect(page).to have_content '現在出品されている商品一覧'
  end

  it 'can sign out' do
    sign_in user
    visit items_path
    click_on 'Menu'
    click_on 'ログアウト'
    expect(page).to have_content 'Welcome'
    expect(page).to have_content 'Discordでログイン'
  end

  it 'can withdraw from this app' do
    sign_in user
    visit items_path
    click_on 'Menu'
    click_on '退会する'
    expect(page).to have_selector('h1', text: '退会')
    expect do
      page.accept_confirm { click_on '退会する' }
      expect(page).to have_content '退会しました'
    end.to change(User, :count).by(-1)
  end

  private

  def discord_mock
    auth_hash = {
      provider: 'discord',
      uid:,
      info: {
        name: 'alice'
      },
      extra: {
        raw_info: {
          avatar: nil
        }
      }
    }
    OmniAuth::AuthHash.new(auth_hash)
  end
end
