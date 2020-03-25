require 'test_helper'

class ContribucionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contribucion = contribucions(:one)
  end

  test "should get index" do
    get contribucions_url
    assert_response :success
  end

  test "should get new" do
    get new_contribucion_url
    assert_response :success
  end

  test "should create contribucion" do
    assert_difference('Contribucion.count') do
      post contribucions_url, params: { contribucion: { text: @contribucion.text, title: @contribucion.title, url: @contribucion.url, user_id: @contribucion.user_id } }
    end

    assert_redirected_to contribucion_url(Contribucion.last)
  end

  test "should show contribucion" do
    get contribucion_url(@contribucion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contribucion_url(@contribucion)
    assert_response :success
  end

  test "should update contribucion" do
    patch contribucion_url(@contribucion), params: { contribucion: { text: @contribucion.text, title: @contribucion.title, url: @contribucion.url, user_id: @contribucion.user_id } }
    assert_redirected_to contribucion_url(@contribucion)
  end

  test "should destroy contribucion" do
    assert_difference('Contribucion.count', -1) do
      delete contribucion_url(@contribucion)
    end

    assert_redirected_to contribucions_url
  end
end
