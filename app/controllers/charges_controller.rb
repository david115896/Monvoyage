class ChargesController < ApplicationController
    def new
    end
    
    def create
      # Amount in cents
      @checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true)
      @amount = Checkout.amount(@checkouts)
      
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
    SoldTicket.multi_save(order, cookies[:organiser_id])
    OrderMailer.order_email(current_user, order).deliver_now
    OrderMailer.order_admin_email(current_user, order).deliver_now
		redirect_to user_path(current_user.id)
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end

end
