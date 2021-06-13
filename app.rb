# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/util'

set :views, "#{settings.root}/views/articles"

filename = 'articles.json'

# ファイルがない場合はファイルを作る
def if_no_article_file_then_create(filename)
  return if File.exist? filename

  dummy_text = '[{"id":0,"title":"メモのサンプル","content":"メモのダミーです。"}]'
  File.open(filename, 'w') do |line|
    line.write(dummy_text)
  end
end

# 出力時にエスケープする
def text_escape(string)
  string = CGI.escape_html(string)
  string.gsub(/\r\n|\r|\n/, '<br>')
end

# jsonを読み込み、ハッシュに変換する
def read_json_file_to_hash(filename)
  File.open(filename) do |line|
    JSON.parse(line.read)
  end
end

get '/' do
  redirect to('/articles')
end

get '/articles' do
  if_no_article_file_then_create(filename)
  @articles = read_json_file_to_hash(filename)

  @page_title = 'becomemo-app'
  erb :index
end

post '/articles' do
  # 入力内容を得る
  hash = {
    id: read_json_file_to_hash(filename).size + 1,
    title: params[:title],
    content: params[:content]
  }

  # 記事一覧に入力内容を追加する
  articles = read_json_file_to_hash(filename).push(hash)

  # json形式でファイルに書き込む
  File.open(filename, 'w') do |line|
    line.write(articles.to_json)
  end

  # 記事一覧ページに飛ぶ
  redirect to('/articles')
end

get '/articles/new' do
  @page_title = 'メモを追加 | becomemo-app'
  erb :new
end

get '/articles/:id' do
  if_no_article_file_then_create(filename)
  articles = read_json_file_to_hash(filename)

  @id = params[:id]
  articles.each do |article|
    if article['id'] == @id.to_i
      @article_title = article['title']
      @article_content = article['content']
    end
  end

  if @article_title
    @page_title = 'メモの詳細 | becomemo-app'
    erb :show
  else
    not_found
  end
end

delete '/articles/:id' do
  articles = read_json_file_to_hash(filename)

  @id = params[:id]
  # idを比較して削除する
  articles.each do |article|
    articles.delete(article) if article['id'] == @id.to_i
  end

  # json形式でファイルに書き込む
  File.open(filename, 'w') do |line|
    line.write(articles.to_json)
  end

  # 一覧に飛ぶ
  redirect to('/articles')
end

patch '/articles/:id' do
  articles = read_json_file_to_hash(filename)

  @id = params[:id]
  # idを比較して入力内容で変更する
  articles.each do |article|
    if article['id'] == @id.to_i
      article['title'] = params[:title]
      article['content'] = params[:content]
    end
  end

  # json形式でファイルに書き込む
  File.open(filename, 'w') do |line|
    line.write(articles.to_json)
  end

  # 記事詳細に飛ぶ
  redirect to("/articles/#{@id}")
end

get '/articles/:id/edit' do
  if_no_article_file_then_create(filename)
  articles = read_json_file_to_hash(filename)

  @id = params[:id]
  articles.each do |article|
    if article['id'] == @id.to_i
      @article_title = article['title']
      @article_content = article['content']
    end
  end

  @page_title = 'メモの編集 | becomemo-app'
  erb :edit
end

not_found do
  @page_title = 'ページが見つかりません | becomemo-app'
  erb :error
end
