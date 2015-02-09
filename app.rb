require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'restaurant_crud',
	host: "localhost", 
	port: 5432
	})

require_relative 'models/food'
require_relative 'models/party'
require_relative 'models/order'
enable :method_override


#------Index-------
	
	get '/'  do
		erb :"/index"
	end

	get '/index'  do
		erb :"/index"
	end

	get '/foods' do 
		@foods = Food.all
		erb :"/foods/index"
	end

	get '/parties' do 
		@parties = Party.all.order(:id)
		erb :"/parties/index"
	end

#------New-------

	get '/foods/new' do
		erb :"/foods/new"
	end

	get '/parties/new' do
		erb :"/parties/new"
	end

	# get '/parties/:id/orders/new' do
	# 	@party = Party.find(params[:id])
	# 	@foods = Food.all.group_by { |x| x.category }
	# 	erb :"orders/new"
	# end

#------Show-------

	get '/foods/:id' do
		@food = Food.find(params[:id])
		erb :"/foods/show"
	end

	get '/parties/:id' do
		party_id = params['id']
		@party = Party.find(party_id)
		@orders = @party.orders
		#for adding food
		@foods = Food.all
		@party_order = @party.foods
		erb :"/parties/show"
	end

	get 'parties/:id/receipt' do 
			@party = Party.find(params[:id])
			@orders = @party.orders
			@party.save_reciept
			
			erb :'/parties/receipt'
	end

	get 'parties/:id/receipt/download' do 
			party = Party.find(params[:id])
			filename = @party.make_filename
			send_file "./public/#{filename}", :filename => filename, :type => 'Application/octet-stream'
	end
#------Create------

	post '/foods' do
		food = Food.create(params[:food])
		redirect to '/foods'
	end


	post '/parties' do
		params[:party][:paid] = 'f'
		party = Party.create(params[:party])
		redirect to '/parties/#{party.id}'
	end

	# post '/parties/:id/orders' do
	# 	params[:new_order][:party_id] = params[:id]
	# 	new_order = Order.create(params[:new_order])
	# 	redirect to "/parties/#{params[:id]}/orders/new"
	# end

	post '/orders' do 
		order = Order.create(params[:order])
		redirect to "/parties/#{order.party_id}"
	end

#------Edit-------

	get '/foods/:id/edit' do
		@food = Food.find(params[:id])
		erb :"/foods/edit"
	end

	get '/parties/:id/edit' do
		@party = Party.find(params[:id])
		erb :"/parties/edit"
	end

#------Update-------

	patch '/foods/:id' do
		food = Food.find(params[:id])
		food.update(params[:food])
		redirect '/foods'
	end

	patch '/parties/:id' do
		@party = Party.find(params[:id])
		@party.update(params[:party])
		@foods = Food.all
		redirect '/parties/#{params[:id]}/receipt'
	end

  patch '/orders/:id' do
    @order = Order.find(params[:id])
    @order.update(params[:order])
    redirect to "/parties/#{@order.party_id}"
  end 


#------Destroy------

	delete '/foods/:id' do
		food = Food.find(params[:id])
		food.destroy
		redirect to '/foods'
	end

	delete '/parties/:id' do 
		party = Party.find(params[:id])
		party.destroy
		redirect to '/parties'
	end

	delete '/orders/:id' do 
    @order = Order.find(params[:id])
    @order.destroy
    redirect to "/parties/#{@order.party_id}"
	end

	#------Receipt--------

	get '/parties/:id/receipt' do
		@party = Party.find(params[:id])
		erb :'order/receipt'
	end

	get '/parties/:id/checkout' do
		@party = Party.find(params[:id])
		erb :'parties/checkout'
	end

	patch '/parties/:id/checkout' do
		@party = Party.find(params[:id])
    @party.total= @party.foods.sum(:price)
		@party.paid = 'true'
    @party.tips = params[:party][:tips]
   	@party.save
		
		redirect to "/parties/#{@party.id}/final"
	end

	get '/parties/:id/final' do
    @party = Party.find(params[:id])
    erb :'parties/final'
  end


	# 	order = Order.where("party_id = params[:id] AND food_id = params[:food][:id]")
	# 	order.delete(order)
	# 	redirect to "/parties/#{params[:id]}/orders/new"
	# end


#------Redirect-----

  get '/consule' do
  	Pry.start(binding)
	end
 get "/*" do
    redirect to("/index")
  end
