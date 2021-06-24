# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/util'

set :views, "#{settings.root}/views/articles"

ARTICLE_FILE = 'articles.json'

# ファイルがない場合はファイルを作る
def if_no_article_file_then_create
  return if File.exist? ARTICLE_FILE

  dummy_text = '[{"id":0,"title":"メモのサンプル","content":"メモのダミーです。"}]'
  File.open(ARTICLE_FILE, 'w') do |line|
    line.write(dummy_text)
  end
end

# 出力時にエスケープする
def text_escape(string)
  string = CGI.escape_html(string)
  string.gsub(/\r\n|\r|\n/, '<br>')
end

# jsonを読み込み、ハッシュに変換する
def read_json_file_to_hash
  File.open(ARTICLE_FILE) do |line|
    JSON.parse(line.read, symbolize_names: true)
  end
end

# json形式でファイルに書き込む
def write_json_file(data)
  File.open(ARTICLE_FILE, 'w') do |line|
    line.write(data.to_json)
  end
end

# idを照らし合わせて記事を取り出す
def same_id_article(articles, id)
  articles.each do |article|
    return article if article[:id] == id.to_i
  end
end

# 一覧を取得
def list_all
  if_no_article_file_then_create
  read_json_file_to_hash
end

# 投稿する
def post_article(title, content)
  hash = {
    id: read_json_file_to_hash.size + 1,
    title: title,
    content: content
  }
  articles = list_all
  articles << hash
  write_json_file(articles)
end

# 特定の記事を取得
def get_article(id)
  articles = list_all
  same_id_article(articles, id)
end

# 記事の削除
def delete_article(id)
  articles = list_all
  articles.delete(same_id_article(articles, id))
  write_json_file(articles)
end

# 記事の編集
def edit_article(id, title, content)
  articles = list_all
  article = same_id_article(articles, id)
  article[:title] = title
  article[:content] = content
  write_json_file(articles)
end

# ルーティング
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
  @article = get_article(params[:id])

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
  @article = get_article(params[:id])
  @page_title = 'メモの編集 | becomemo-app'
  erb :edit
end

not_found do
  @page_title = 'ページが見つかりません | becomemo-app'
  erb :error
end
