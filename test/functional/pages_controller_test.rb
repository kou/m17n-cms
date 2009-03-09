require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  def test_should_get_index_page_when_no_pages
    Page.destroy_all
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
    assert_equal(["index"], Page.find(:all).collect(&:name))
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page" do
    assert_difference('Page.count') do
      post :create, :page => { }
    end

    assert_redirected_to page_path(assigns(:page))
  end

  test "should show page" do
    get :show, :id => pages(:index).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pages(:index).id
    assert_response :success
  end

  test "should update page" do
    put :update, :id => pages(:index).id, :page => { }
    assert_redirected_to page_path(assigns(:page))
  end

  test "should destroy page" do
    assert_difference('Page.count', -1) do
      delete :destroy, :id => pages(:index).id
    end

    assert_redirected_to pages_path
  end
end
