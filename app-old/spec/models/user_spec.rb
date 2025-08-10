# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_from_auth_hash!' do
    let(:uid) { '2345678' }
    let(:auth_hash) do
      {
        provider: 'discord',
        uid:,
        info: {
          name: 'bob'
        },
        extra: {
          raw_info: {
            avatar: nil
          }
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
        expect(user.avatar_url).to eq 'https://cdn.discordapp.com/embed/avatars/0.png'
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

  describe 'methods for handling user events' do
    let(:alice) { FactoryBot.create(:user) }
    let(:event_user_data) { instance_double(Discordrb::User) }

    describe '.remove_by_member_leaving_event' do
      it 'deletes the user by an event that the user leaves a specific server' do
        allow(event_user_data).to receive(:id).and_return(alice.uid)
        event = instance_double(Discordrb::Events::ServerMemberDeleteEvent)
        allow(event).to receive(:user).and_return(event_user_data)

        expect { User.remove_by_member_leaving_event(event) }.to change(User, :count).by(-1)
        expect(User.find_by(uid: alice.uid)).to be_nil
      end
    end

    describe '.update_by_member_updating_event' do
      it 'updates the user by an event that the user updates the user information' do
        allow(event_user_data).to receive(:id).and_return(alice.uid)
        event = instance_double(Discordrb::Events::ServerMemberUpdateEvent)
        allow(event).to receive(:user).and_return(event_user_data)
        stub_request(:get, "#{Discordrb::API.api_base}/users/#{alice.uid}")
          .to_return_json(body: { id: alice.uid, username: 'renamed_alice', avatar: '1234567' })

        User.update_by_member_updating_event(event)
        alice.reload
        expect(alice.name).to eq 'renamed_alice'
        expect(alice.avatar_url).to eq "https://cdn.discordapp.com/avatars/#{alice.uid}/1234567.webp"
      end
    end
  end
end
