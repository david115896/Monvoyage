class OrderMailer < ApplicationMailer

    def order_email(user, order)
        @user = user  
        @order = order 
        @amount = 0
        order.sold_tickets.each do |sold_ticket|
            @amount += sold_ticket.ticket.price
        end
    
        @url  = 'https://my-travel-thp.herokuapp.com/'
        
        mail(to: @user.email, subject: 'Thanks for your order')
    end

    def order_admin_email(buyer, order)

		admins = User.where(is_admin: true)
		@buyer = buyer
        @order = order
        @amount = 0
        order.sold_tickets.each do |sold_ticket|
            @amount += sold_ticket.ticket.price
        end

		for admin in admins
			@user = admin 
			@url  = 'https://my-travel-thp.herokuapp.com/admin/users' 
			mail(to: @user.email, subject: 'Order received') 
		end
	end
   
end
