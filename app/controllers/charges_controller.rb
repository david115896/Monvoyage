class ChargesController < ApplicationController
    def new
    end
    
    def create
      # Amount in cents
			checkouts = Checkout.where(organiser_id: session[:organiser_id])
      @amount = 500
    
      customer = Stripe::Customer.create({
        email: params[:stripeEmail],
        source: params[:stripeToken],
      })
    
      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: @amount,
        description: 'Rails Stripe customer',
        currency: 'usd',
      })
    
		order = Order.add_order(current_user)
		SoldTicket.multi_save(order, session[:organiser_id])
		redirect_to user_path(current_user.id)
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end

end
