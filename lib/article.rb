# frozen_string_literal: true

class Article
  ARTICLE_FILE = 'articles.json'

  def if_no_article_file_then_create
    return if File.exist? ARTICLE_FILE
  
    dummy_text = '[{"id":1,"title":"メモのサンプル","content":"メモのダミーです。"}]'
    File.open(ARTICLE_FILE, 'w') do |line|
      line.write(dummy_text)
    end
  end

  def initialize
    if_no_article_file_then_create
  end

  def read_json_file_to_hash
    File.open(ARTICLE_FILE) do |line|
      JSON.parse(line.read, symbolize_names: true)
    end
  end

  def write_json_file(data)
    File.open(ARTICLE_FILE, 'w') do |line|
      line.write(data.to_json)
    end
  end

  def same_id_article(articles, id)
    articles.each do |article|
      return article if article[:id] == id.to_i
    end
  end

  def list
    read_json_file_to_hash
  end

  def create(title, content)
    hash = {
      id: read_json_file_to_hash.size + 1,
      title: title,
      content: content
    }
    articles = list
    articles << hash
    write_json_file(articles)
  end

  def get(id)
    articles = list
    same_id_article(articles, id)
  end

  def drop(id)
    articles = list
    articles.delete(same_id_article(articles, id))
    write_json_file(articles)
  end

  def edit(id, title, content)
    articles = list
    article = same_id_article(articles, id)
    article[:title] = title
    article[:content] = content
    write_json_file(articles)
  end
end
