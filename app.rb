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
    JSON.parse(line.read, symbolize_names: true)
  end
end

# json形式でファイルに書き込む
def write_json_file(filename, data)
  File.open(filename, 'w') do |line|
    line.write(data.to_json)
  end
end

# idを照らし合わせて記事を取り出す
def same_id_article(articles, id)
  articles.each do |article|
    if article[:id] == id.to_i
      return article
    end
  end
end

# ルーティング
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
  write_json_file(filename, articles)

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
  @article = same_id_article(articles, params[:id])

  if @article
    @page_title = 'メモの詳細 | becomemo-app'
    erb :show
  else
    not_found
  end
end

delete '/articles/:id' do
  articles = read_json_file_to_hash(filename)
  articles.delete(same_id_article(articles, params[:id]))
  write_json_file(filename, articles)

  # 一覧に飛ぶ
  redirect to('/articles')
end

patch '/articles/:id' do
  articles = read_json_file_to_hash(filename)

  article = same_id_article(articles, params[:id])
  article[:title] = params[:title]
  article[:content] = params[:content]
  write_json_file(filename, articles)

  # 記事詳細に飛ぶ
  redirect to("/articles/#{params[:id]}")
end

get '/articles/:id/edit' do
  if_no_article_file_then_create(filename)
  articles = read_json_file_to_hash(filename)
  @article = same_id_article(articles, params[:id])

  @page_title = 'メモの編集 | becomemo-app'
  erb :edit
end

not_found do
  @page_title = 'ページが見つかりません | becomemo-app'
  erb :error
end
