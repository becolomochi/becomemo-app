require 'sinatra'
require 'sinatra/reloader'

get '/detail/*/edit' do |id|
  erb :detail_edit
end

get '/detail/*' do |id|
  erb :detail
end

get '/add' do
  erb :add
end

get '/' do
  erb :index
end

# TODO: 404
