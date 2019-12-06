require "application_system_test_case"

class OrganisersTest < ApplicationSystemTestCase
  setup do
    @organiser = organisers(:one)
  end

  test "visiting the index" do
    visit organisers_url
    assert_selector "h1", text: "Organisers"
  end

  test "creating a Organiser" do
    visit organisers_url
    click_on "New Organiser"

    click_on "Create Organiser"

    assert_text "Organiser was successfully created"
    click_on "Back"
  end

  test "updating a Organiser" do
    visit organisers_url
    click_on "Edit", match: :first

    click_on "Update Organiser"

    assert_text "Organiser was successfully updated"
    click_on "Back"
  end

  test "destroying a Organiser" do
    visit organisers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Organiser was successfully destroyed"
  end
end
