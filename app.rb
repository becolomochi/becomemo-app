require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :views, settings.root + '/views/articles'

filename = 'articles.json'

# jsonを読み込み、ハッシュに変換する
def articles(filename)
  File.open(filename) do |line|
    hash = JSON.load(line)
  end
end

get '/' do
  redirect to('/articles')
end

get '/articles' do
  @page_title = 'memo-app'

  @articles = articles(filename)

  erb :index
end

post '/articles/new' do
  # 入力内容を得る
  hash = {
    id: articles(filename).size + 1,
    title: params[:title],
    content: params[:content]
  }

  # 記事一覧に入力内容を追加する
  articles = articles(filename).push(hash)

  # json形式でファイルに書き込む
  File.open(filename, "w") do |line|
    line.write(articles.to_json)
  end

  # 記事一覧ページに飛ぶ
  redirect to('/articles')
end

get '/articles/new' do
  @page_title = 'メモを追加'

  erb :new
end

get '/articles/:id' do |id|
  @page_title = 'メモの詳細'

  # jsonファイルを読み込む
  @articles = articles(filename)

  @id = params[:id]
  @articles.each do |article|
    if article['id'] == @id.to_i
      @article_title = article['title']
      @article_content = article['content']
    end
  end

  erb :show
end

delete '/articles/:id' do
  # TODO: jsonファイルからメモを削除する実装
end

patch '/articles/:id/edit' do
  @id = params[:id]

  # jsonファイルを読み込む
  @articles = articles(filename)

  # idを比較して入力内容で変更する
  @articles.each do |article|
    if article['id'] == @id.to_i
      article['title'] = params[:title]
      article['content'] = params[:content]
    end
  end

  # json形式でファイルに書き込む
  File.open(filename, 'w') do |line|
    line.write(@articles.to_json)
  end

  # 記事詳細に飛ぶ
  redirect to("/articles/#{@id}")
end

get '/articles/:id/edit' do |id|
  @page_title = 'メモを編集'

  # jsonファイルを読み込む
  @articles = articles(filename)

  @id = params[:id]
  @articles.each do |article|
    if article['id'] == @id.to_i
      @article_title = article['title']
      @article_content = article['content']
    end
  end

  erb :edit
end

# TODO: 404
