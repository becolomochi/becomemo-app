require 'sinatra'
require 'sinatra/reloader'

set :views, settings.root + '/views/articles'

get '/articles/*/edit' do |id|
  erb :edit
end

get '/articles/*' do |id|
  erb :show
end

get '/articles/new' do
  erb :new
end

get '/articles' do
  erb :index
end

# TODO: 404
