class PartiesController < ApplicationController

	get '/' do 
		@parties = Party.all
		erb :"/parties/index"
	end

	get '/new' do
		erb :"/parties/new"
	end

	get '/:id' do
		@party = Party.find(params[:id])
		@orders = @party.orders
		#for adding food
		@foods = Food.all
		@party_order = @party.foods
		erb :"/parties/show"
	end

	get '/:id/receipt' do 
			@party = Party.find(params[:id])
			@orders = @party.orders
			@party.save_reciept
			
			erb :'/parties/receipt'
	end

	get '/:id/receipt/download' do 
			party = Party.find(params[:id])
			filename = @party.make_filename
			send_file "./public/#{filename}", :filename => filename, :type => 'Application/octet-stream'
	end

	post '/' do
		party = Party.create(params[:party])
		redirect to '/parties'
	end

	get '/:id/edit' do
		@party = Party.find(params[:id])
		erb :"/parties/edit"
	end

	patch '/:id' do
		party = Party.find(params[:id])
		party.update(params[:party])
		redirect '/parties'
	end

	 patch "/:id/checkout" do 
  	@party = Party.find(params[:id])
  	@party.update(meal_paid: "t")
  	redirect to "/parties/#{@party.id}/receipt"
  end

  delete '/:id' do 
		party = Party.find(params[:id])
		party.destroy
		redirect to '/parties'
	end

	get '/:id/receipt' do
		@party = Party.find(params[:id])
		erb :'parties/receipt'
	end

	patch '/:id/checkout' do
		@party = Party.find(params[:id])
    @party.total= @party.foods.sum(:price)
		@party.paid = 'true'
    @party.tips = params[:party][:tips]
   	@party.save
		
		redirect to "/parties/#{@party.id}/receipt"
	end

	get '/:id/final' do
    @party = Party.find(params[:id])
    erb :'parties/final'
  end



end
