# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#find_or_create_from_auth_hash!' do
    let(:uid) { '2345678' }
    let(:auth_hash) do
      {
        provider: 'discord',
        uid:,
        info: {
          name: 'bob',
          image: 'https://cdn.discordapp.com/embed/avatars/1.png'
        }
      }
    end

    before do
      stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{uid}")
    end

    context 'when the user is new' do
      it 'creates and returns a new user' do
        user = User.find_or_create_from_auth_hash!(auth_hash)
        expect(user.provider).to eq 'discord'
        expect(user.uid).to eq '2345678'
        expect(user.name).to eq 'bob'
        expect(user.avatar_url).to eq 'https://cdn.discordapp.com/embed/avatars/1.png'
        expect(User.find_or_create_from_auth_hash!(auth_hash)).to eq User.find_by(uid:)
      end

      it 'increases the user count by 1' do
        expect { User.find_or_create_from_auth_hash!(auth_hash) }.to change(User, :count).from(0).to(1)
      end
    end

    context 'when the user already exists' do
      let!(:existing_user) { FactoryBot.create(:user, uid:) }

      it 'returns the existing user' do
        user = User.find_or_create_from_auth_hash!(auth_hash)
        expect(user).to eq existing_user
      end

      it "doesn't change the user count" do
        expect { User.find_or_create_from_auth_hash!(auth_hash) }.not_to change(User, :count)
      end
    end
  end
end
