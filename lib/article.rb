# frozen_string_literal: true

require 'pg'

class Article
  @connect = PG.connect(dbname: 'becomemo')

  def self.list
    @connect.exec('SELECT * FROM Article ORDER BY id DESC') do |articles|
      articles.map { |article| article.transform_keys!(&:to_sym) }
    end
  end

  def self.latest_id
    return 0 if list.empty?

    list.map { |article| article[:id].to_i }.max
  end

  def self.create(title, content)
    id = latest_id + 1
    data = 'INSERT INTO article VALUES ($1, $2, $3)'
    @connect.exec(data, [id, title, content])
  end

  def self.get(id)
    list.find { |article| article[:id].to_i == id }
  end

  def self.drop(id)
    data = 'DELETE FROM Article WHERE id=$1'
    @connect.exec(data, [id])
  end

  def self.edit(id, title, content)
    data = 'UPDATE Article SET title=$1, content=$2 WHERE id=$3'
    @connect.exec(data, [title, content, id])
  end
end
