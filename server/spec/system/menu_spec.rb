# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Menu', type: :system do
  let(:alice) { FactoryBot.create(:user) }

  it 'user can use Menu button' do
    sign_in alice
    visit items_path
    click_on 'メニュー'
    expect(page).to have_link '自分の商品一覧'
    expect(page).to have_link '購入希望一覧'
    expect(page).to have_link 'ログアウト'
  end
end
