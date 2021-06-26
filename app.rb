# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/util'
require './lib/article'

set :views, "#{settings.root}/views/articles"

get '/' do
  redirect to('/articles')
end

get '/articles' do
  @articles = list_all

  @page_title = 'becomemo-app'
  erb :index
end

post '/articles' do
  post_article(params[:title], params[:content])
  redirect to('/articles')
end

get '/articles/new' do
  @page_title = 'メモを追加 | becomemo-app'
  erb :new
end

get '/articles/:id' do
  @article = find_article(params[:id])

  if @article
    @page_title = 'メモの詳細 | becomemo-app'
    erb :show
  else
    not_found
  end
end

delete '/articles/:id' do
  delete_article(params[:id])
  redirect to('/articles')
end

patch '/articles/:id' do
  edit_article(params[:id], params[:title], params[:content])
  redirect to("/articles/#{params[:id]}")
end

get '/articles/:id/edit' do
  @article = find_article(params[:id])
  @page_title = 'メモの編集 | becomemo-app'
  erb :edit
end

not_found do
  @page_title = 'ページが見つかりません | becomemo-app'
  erb :error
end
