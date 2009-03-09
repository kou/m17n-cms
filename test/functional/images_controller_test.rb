require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  def setup
    FileUtils.rm_rf(File.join(RAILS_ENV, IMAGE_DIRECTORY))
    FileUtils.mkdir_p(File.join(RAILS_ENV, IMAGE_DIRECTORY))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:images)
  end

  def test_should_create_image
    assert_difference('Image.count') do
      post :create, :image => {:image_file => png("rails.png")}
    end

    assert_redirected_to(formatted_image_path(assigns(:image),
                                              :format => "html"))
  end

  test "should show image" do
    get :show, :id => images(:rails).id
    assert_response :success
  end

  test "should destroy image" do
    assert_difference('Image.count', -1) do
      delete :destroy, :id => images(:rails).id
    end

    assert_redirected_to images_path
  end

  private
  def png(file)
    path = File.join(Test::Unit::TestCase.fixture_path, 'images', file)
    ActionController::TestUploadedFile.new(path, 'image/png', :binary)
  end
end
