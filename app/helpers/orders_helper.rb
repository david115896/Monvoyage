module OrdersHelper

    def amount_order(order)
        amount = 0
        order.tickets.each do |ticket|
            amount += ticket.price
        end
        return amount
	end
end
