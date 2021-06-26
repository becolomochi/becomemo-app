# frozen_string_literal: true

require 'minitest/autorun'
require './app'

ARTICLE_FILE = 'articles.json'

class ArticleTest < Minitest::Test
  def setup
    File.delete(ARTICLE_FILE) if File.exist? ARTICLE_FILE
  end

  def test_article_read_file
    article = Article.new
    assert_equal [{:id=>1, :title=>"メモのサンプル", :content=>"メモのダミーです。"}], article.read_json_file_to_hash
  end

  def test_article_latest_id
    article = Article.new
    assert_equal 1, article.latest_id
  end

  def test_article_list
    article = Article.new
    assert_equal [{:id=>1, :title=>"メモのサンプル", :content=>"メモのダミーです。"}], article.list
  end

  def test_article_create
    article = Article.new
    article.create('title', 'content')
    article.create('title2', 'content2')
    assert_equal [{:id=>1, :title=>"メモのサンプル", :content=>"メモのダミーです。"},{:id=>2, :title=>"title", :content=>"content"},{:id=>3, :title=>"title2", :content=>"content2"}], article.read_json_file_to_hash
  end

  def test_article_get
    article = Article.new
    id = 1
    get_article = article.get(id)
    assert_equal get_article[:id], 1
    assert_equal get_article[:title], "メモのサンプル"
    assert_equal get_article[:content], "メモのダミーです。"
  end

  def test_article_drop
    article = Article.new
    id = 1
    article.drop(id)
    assert_equal [], article.get(id)
  end

  def test_article_edit
    article = Article.new
    id = 1
    title = "メモ修正"
    content = "メモ本文修正"
    article.edit(id, title, content)
    get_article = article.get(id)
    assert_equal get_article[:id], 1
    assert_equal get_article[:title], "メモ修正"
    assert_equal get_article[:content], "メモ本文修正"
  end

  def test_article_not_duplicate_id
    article = Article.new
    article.create("タイトル","本文")
    article.create("タイトル2","本文2")
    article.drop(2)
    article.create("タイトル3","本文3")
    assert_equal 4, article.latest_id
  end
end
