class ChargesController < ApplicationController
    def new
    end
    
    def create
      # Amount in cents
			checkouts = Checkout.where(organiser_id: session[:organiser_id])
      @amount = Checkout.amount(current_user).to_i

      customer = Stripe::Customer.create({
        email: params[:stripeEmail],
        source: params[:stripeToken],
      })
    
      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: 100 * @amount.to_i,
        description: 'Rails Stripe customer',
        currency: 'usd',
      })
    
		order = Order.add_order(current_user)
		SoldTicket.multi_save(order, current_user)
		redirect_to user_path(current_user.id)
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end

end
