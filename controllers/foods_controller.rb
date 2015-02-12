class FoodsController < ApplicationController


	get '/' do
		@foods = Food.all
		erb :"/foods/index"
	end

	get '/new' do
		erb :"/foods/new"
	end

	get '/:id' do
		@food = Food.find(params[:id])
		erb :"/foods/show"
	end

	post '/' do
		food = Food.create(params[:food])
		redirect to '/foods'
	end

	get '/:id/edit' do
		@food = Food.find(params[:id])
		erb :"/foods/edit"
	end

	patch '/:id' do
		food = Food.find(params[:id])
		food.update(params[:food])
		redirect '/foods'
	end

	delete '/:id' do
		food = Food.find(params[:id])
		food.destroy
		redirect to '/foods'
	end

end
