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

  def list
    File.open(ARTICLE_FILE) do |line|
      JSON.parse(line.read, symbolize_names: true)
    end
  end

  def write_json_file(data)
    File.open(ARTICLE_FILE, 'w') do |line|
      line.write(data.to_json)
    end
  end

  def latest_id
    list.last[:id]
  end

  def create(title, content)
    hash = {
      id: latest_id + 1,
      title: title,
      content: content
    }
    write_json_file(list << hash)
  end

  def get(articles, id)
    articles.each do |article|
      return article if article[:id] == id.to_i
    end
  end

  def drop(id)
    articles = list
    articles.delete(get(articles, id))
    write_json_file(articles)
  end

  def edit(id, title, content)
    articles = list
    article = get(articles, id)
    article[:title] = title
    article[:content] = content
    write_json_file(articles)
  end
end
