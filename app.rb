# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi/util'
require './lib/article'

set :views, "#{settings.root}/views/articles"

def text_escape(string)
  string = CGI.escape_html(string)
  string.gsub(/\r\n|\r|\n/, '<br>')
end

get '/' do
  redirect to('/articles')
end

get '/articles' do
  article = Article.new
  @articles = article.list
  @page_title = 'becomemo-app'
  erb :index
end

post '/articles' do
  article = Article.new
  article.create(params[:title], params[:content])
  redirect to('/articles')
end

get '/articles/new' do
  @page_title = 'メモを追加 | becomemo-app'
  erb :new
end

get '/articles/:id' do
  article = Article.new
  @article = article.get(article.list, params[:id])
  if @article
    @page_title = 'メモの詳細 | becomemo-app'
    erb :show
  else
    not_found
  end
end

delete '/articles/:id' do
  article = Article.new
  article.drop(params[:id])
  redirect to('/articles')
end

patch '/articles/:id' do
  article = Article.new
  article.edit(params[:id], params[:title], params[:content])
  redirect to("/articles/#{params[:id]}")
end

get '/articles/:id/edit' do
  article = Article.new
  @article = article.get(article.list, params[:id])
  @page_title = 'メモの編集 | becomemo-app'
  erb :edit
end

not_found do
  @page_title = 'ページが見つかりません | becomemo-app'
  erb :error
end
