require "application_system_test_case"

class SoldTicketsTest < ApplicationSystemTestCase
  setup do
    @sold_ticket = sold_tickets(:one)
  end

  test "visiting the index" do
    visit sold_tickets_url
    assert_selector "h1", text: "Sold Tickets"
  end

  test "creating a Sold ticket" do
    visit sold_tickets_url
    click_on "New Sold Ticket"

    click_on "Create Sold ticket"

    assert_text "Sold ticket was successfully created"
    click_on "Back"
  end

  test "updating a Sold ticket" do
    visit sold_tickets_url
    click_on "Edit", match: :first

    click_on "Update Sold ticket"

    assert_text "Sold ticket was successfully updated"
    click_on "Back"
  end

  test "destroying a Sold ticket" do
    visit sold_tickets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sold ticket was successfully destroyed"
  end
end
