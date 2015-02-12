class OrdersController < ApplicationController

	get '/' do
		erb :"orders/index"
	end

	post '/' do 
		order = Order.create(params[:order])
		redirect to "/parties/#{order.party_id}"
	end

	patch '/:id' do
    @order = Order.find(params[:id])
    @order.update(params[:order])
    redirect to "/parties/#{@order.party_id}"
  end 

  delete '/:id' do 
    @order = Order.find(params[:id])
    @order.destroy
    redirect to "/parties/#{@order.party_id}"
	end

end
