# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:alice) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item, user: alice) }

  it 'user can post, update and delete a comment' do
    sign_in alice
    visit item_path(item)

    expect(page).to have_content '(0)'
    fill_in 'comment[content]', with: 'テストコメント'
    click_button 'コメントする'
    expect(page).to have_content 'コメントを投稿しました'
    expect(page).to have_content '(1)'

    within "#comment_#{item.comments.first.id}" do
      expect(page).to have_content 'テストコメント'
      click_link '編集'
      fill_in 'comment[content]', with: '編集したテストコメント'
      click_button '更新'
    end
    expect(page).to have_content 'コメントを更新しました'

    expect do
      within "#comment_#{item.comments.first.id}" do
        expect(page).to have_content '編集したテストコメント'
        click_link '削除'
      end
      expect(page).to have_content 'コメントを削除しました'
      expect(page).to have_content '(0)'
    end.to change(Comment, :count).by(-1)

    within '.comment-container' do
      expect(page).not_to have_content '編集したテストコメント'
    end
  end

  it "user can't update and delete other user's comment" do
    bob = FactoryBot.create(:user, name: 'bob')
    comment = FactoryBot.create(:comment, item:, user: bob)

    sign_in alice
    visit item_path(item)
    within "#comment_#{comment.id}" do
      expect(page).to have_content 'テストコメントです'
      expect(page).not_to have_link '編集'
      expect(page).not_to have_link '削除'
    end

    sign_in bob
    visit item_path(item)
    within "#comment_#{comment.id}" do
      expect(page).to have_content 'テストコメントです'
      expect(page).to have_link '編集'
      expect(page).to have_link '削除'
    end
  end

  it 'user can cansel edit a comment' do
    comment = FactoryBot.create(:comment, item:, user: alice)

    sign_in alice
    visit item_path(item)

    expect(page).to have_content '(1)'
    within "#comment_#{comment.id}" do
      expect(page).to have_content 'テストコメントです'
      click_link '編集'
      fill_in 'comment[content]', with: '編集しようとしたテストコメント'
      click_link 'キャンセル'
      expect(page).to have_link '編集'
    end

    expect(comment.content).to eq 'テストコメントです'
    expect(page).to have_content '(1)'
  end
end
