require 'test_helper'

class SoldTicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sold_ticket = sold_tickets(:one)
  end

  test "should get index" do
    get sold_tickets_url
    assert_response :success
  end

  test "should get new" do
    get new_sold_ticket_url
    assert_response :success
  end

  test "should create sold_ticket" do
    assert_difference('SoldTicket.count') do
      post sold_tickets_url, params: { sold_ticket: {  } }
    end

    assert_redirected_to sold_ticket_url(SoldTicket.last)
  end

  test "should show sold_ticket" do
    get sold_ticket_url(@sold_ticket)
    assert_response :success
  end

  test "should get edit" do
    get edit_sold_ticket_url(@sold_ticket)
    assert_response :success
  end

  test "should update sold_ticket" do
    patch sold_ticket_url(@sold_ticket), params: { sold_ticket: {  } }
    assert_redirected_to sold_ticket_url(@sold_ticket)
  end

  test "should destroy sold_ticket" do
    assert_difference('SoldTicket.count', -1) do
      delete sold_ticket_url(@sold_ticket)
    end

    assert_redirected_to sold_tickets_url
  end
end
