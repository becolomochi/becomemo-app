require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :views, settings.root + '/views/articles'

get '/' do
  redirect to('/articles')
end

get '/articles' do
  @page_title = 'memo-app'

  # jsonを読み込み、ハッシュに変換する
  file = 'articles.json'
  File.open(file) do |line|
    hash = JSON.load(line)
    @articles = hash["articles"]
  end

  erb :index
end

post '/articles' do
  # TODO: jsonファイルにメモを書き込む実装
end

get '/articles/new' do
  @page_title = 'メモを追加'

  erb :new
end

get '/articles/:id' do |id|
  @page_title = 'メモの詳細'

  @id = params[:id]

  erb :show
end

delete '/articles/:id' do
  # TODO: jsonファイルからメモを削除する実装
end

patch '/articles/:id' do
  # TODO: jsonファイルにメモを編集する実装
end

get '/articles/:id/edit' do |id|
  @page_title = 'メモを編集'

  @id = params[:id]

  erb :edit
end

# TODO: 404
