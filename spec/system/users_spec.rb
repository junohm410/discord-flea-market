# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    OmniAuth.config.test_mode = true
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    OmniAuth.config.mock_auth[:discord] = discord_mock
  end

  it 'can sign in' do
    visit root_path
    click_on 'Discordでログイン'
    expect(page).to have_content 'Successfully authenticated from Discord account.'
    expect(page).to have_content '現在出品されている商品一覧'
  end

  it 'can sign out' do
    sign_in user
    visit items_path
    click_on 'ログアウト'
    expect(page).to have_content 'Welcome'
    expect(page).to have_content 'Discordでログイン'
  end

  private

  def discord_mock
    auth_hash = {
      provider: 'discord',
      uid: '1234567',
      info: {
        name: 'alice',
        image: 'https://cdn.discordapp.com/embed/avatars/1.png'
      }
    }
    OmniAuth::AuthHash.new(auth_hash)
  end
end
