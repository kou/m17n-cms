# -*- coding: utf-8 -*-

require 'test_helper'

class PageAdminTest < ActionController::IntegrationTest
  fixtures :all

  def test_create
    visit("/")
    fill_in("名前", :with => "new-page")
    click_button("作成")
    assert_contain("ページを作成しました。")
  end

  def test_update
    visit("/")
    click_link("編集")
    fill_in("名前", :with => "new-page")
    click_button("更新")
    assert_contain("ページを更新しました。")
  end
end
