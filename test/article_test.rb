# frozen_string_literal: true

require 'minitest/autorun'
require './app'

ARTICLE_FILE = 'articles.json'

class ArticleTest < Minitest::Test
  def setup
    File.delete(ARTICLE_FILE) if File.exist? ARTICLE_FILE
    @article = Article.new
    @article.if_no_article_file_then_create
  end

  def test_article_read_file
    assert_equal [{:id=>1, :title=>"メモのサンプル", :content=>"メモのダミーです。"}], @article.read_json_file_to_hash
  end

  def test_article_write_file
    data = {:id=>2, :title=>"title", :content=>"content"}
    @article.write_json_file(@article.read_json_file_to_hash << data)
    assert_equal [{:id=>1, :title=>"メモのサンプル", :content=>"メモのダミーです。"},{:id=>2, :title=>"title", :content=>"content"}], @article.read_json_file_to_hash
  end

  def test_article_list
    assert_equal [{:id=>1, :title=>"メモのサンプル", :content=>"メモのダミーです。"}], @article.list
  end

  def test_article_create
    title = 'title'
    content = 'content'
    @article.create(title, content)
    assert_equal [{:id=>1, :title=>"メモのサンプル", :content=>"メモのダミーです。"},{:id=>2, :title=>"title", :content=>"content"}], @article.read_json_file_to_hash
  end

  def test_article_get
    id = 1
    get_article = @article.get(id)
    assert_equal get_article[:id], 1
    assert_equal get_article[:title], "メモのサンプル"
    assert_equal get_article[:content], "メモのダミーです。"
  end

  def test_article_drop
    id = 1
    @article.drop(id)
    assert_equal [], @article.get(id)
  end

  def test_article_edit
    id = 1
    title = "メモ修正"
    content = "メモ本文修正"
    @article.edit(id, title, content)
    get_article = @article.get(id)
    assert_equal get_article[:id], 1
    assert_equal get_article[:title], "メモ修正"
    assert_equal get_article[:content], "メモ本文修正"
  end
end
