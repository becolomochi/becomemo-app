# frozen_string_literal: true

require 'pg'

class Article
  def initialize
    @connect = PG.connect(dbname: 'becomemo')
  end

  def list
    array = []
    @connect.exec('SELECT * FROM Article ORDER BY id DESC') do |articles|
      articles.each do |article|
        array << article.transform_keys!(&:to_sym)
      end
    end
    array
  end

  def latest_id
    id = 0
    list.each do |article|
      article_id = article[:id].to_i
      id = article_id if id < article_id
    end
    id
  end

  def create(title, content)
    id = latest_id + 1
    data = "INSERT INTO article VALUES (#{id}, '#{title}', '#{content}')"
    @connect.exec(data)
  end

  def get(articles, id)
    articles.each do |article|
      return article if article[:id].to_i == id
    end
  end

  def drop(id)
    data = 'DELETE FROM Article WHERE id=$1'
    @connect.exec(data, [id])
  end

  def edit(id, title, content)
    data = 'UPDATE Article SET title=$1, content=$2 WHERE id=$3'
    @connect.exec(data, [title, content, id])
  end
end
