# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:alice) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item, user: alice) }

  it 'user can post and delete a comment' do
    sign_in alice
    visit item_path(item)

    fill_in 'comment[content]', with: 'テストコメント'
    click_button 'コメントする'

    expect(page).to have_content 'コメントを投稿しました'
    within '.comment-container' do
      expect(page).to have_content 'テストコメント'
      click_button '削除'
    end
    expect(page).to have_content 'コメントを削除しました'
    within '.comment-container' do
      expect(page).not_to have_content 'テストコメント'
    end
  end

  it "user can't delete other user's comment" do
    bob = FactoryBot.create(:user, name: 'bob')
    FactoryBot.create(:comment, item:, user: bob)

    sign_in alice
    visit item_path(item)
    within '.comment-container' do
      expect(page).to have_content 'テストコメントです'
      expect(page).not_to have_button '削除'
    end

    sign_in bob
    visit item_path(item)
    within '.comment-container' do
      expect(page).to have_content 'テストコメントです'
      expect(page).to have_button '削除'
    end
  end
end
