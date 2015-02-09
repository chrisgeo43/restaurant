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

#------Create------

	post '/foods' do
		food = Food.create(params[:food])
		redirect to '/foods'
	end


	post '/parties' do
		params[:party][:paid] = 'f'
		party = Party.create(params[:party])
		redirect to '/parties/'
	end

	# post '/parties/:id/orders' do
	# 	params[:new_order][:party_id] = params[:id]
	# 	new_order = Order.create(params[:new_order])
	# 	redirect to "/parties/#{params[:id]}/orders/new"
	# end

	post '/orders' do 
		id = params[:order][:food_id]
		food = Food.find(id)
		params[:order][:price] = food.price
		party_id = params[:order][:party_id]
		party = Party.find(party_id)
		Order.create(params[:order])
		redirect to "/parties/#{params[:party_id]}"
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
		party = Party.find(params[:id])
		party.update(params[:party])
		redirect '/parties/#{params[:id]}/receipt'
	end

	patch "/parties/:id/checkout" do
    id = params[:id]
    party = Party.find(id)
    params[:party][:total] = party.get_total
    party.update(params[:party])

    redirect to "/parties"
  end

#------Show-------

	get '/foods/:id' do
		@food = Food.find(params[:id])
		@orders = @food.orders
		erb :"/foods/show"
	end

	get '/parties/:id' do
		party_id = params['id']
		@party = Party.find(party_id)
		@foods = Food.all
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

	delete '/orders/:id' do |id|
		food_id = params[:food_id]["id"]
		order = Order.find_by(food_id: food_id,party_id:id)
		order.destroy
		party = Party.find(id)
		redirect to "/orders/:id"
	end

	# delete '/parties/:id/orders' do
	# params[:new_order][:party_id] = params[:id]
	# 	new_order = Order.delete(params[:new_order])
	# 	redirect to "/parties/#{params[:id]}/orders/new"
	# end

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
