require 'test_helper'

class ComentarisControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get comentaris_new_url
    assert_response :success
  end

  test "should get create" do
    get comentaris_create_url
    assert_response :success
  end

  test "should get update" do
    get comentaris_update_url
    assert_response :success
  end

  test "should get edit" do
    get comentaris_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get comentaris_destroy_url
    assert_response :success
  end

  test "should get show" do
    get comentaris_show_url
    assert_response :success
  end

  test "should get index" do
    get comentaris_index_url
    assert_response :success
  end

end
