require "application_system_test_case"

class ContribucionsTest < ApplicationSystemTestCase
  setup do
    @contribucion = contribucions(:one)
  end

  test "visiting the index" do
    visit contribucions_url
    assert_selector "h1", text: "Contribucions"
  end

  test "creating a Contribucion" do
    visit contribucions_url
    click_on "New Contribucion"

    fill_in "Text", with: @contribucion.text
    fill_in "Title", with: @contribucion.title
    fill_in "Url", with: @contribucion.url
    fill_in "User", with: @contribucion.user_id
    click_on "Create Contribucion"

    assert_text "Contribucion was successfully created"
    click_on "Back"
  end

  test "updating a Contribucion" do
    visit contribucions_url
    click_on "Edit", match: :first

    fill_in "Text", with: @contribucion.text
    fill_in "Title", with: @contribucion.title
    fill_in "Url", with: @contribucion.url
    fill_in "User", with: @contribucion.user_id
    click_on "Update Contribucion"

    assert_text "Contribucion was successfully updated"
    click_on "Back"
  end

  test "destroying a Contribucion" do
    visit contribucions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Contribucion was successfully destroyed"
  end
end
