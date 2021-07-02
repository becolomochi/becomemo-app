# frozen_string_literal: true

require 'minitest/autorun'
require './app'

class ArticleTest < Minitest::Test
  def setup
    @connect = PG.connect(dbname: 'becomemo')
    @connect.exec('DELETE FROM Article')
    @connect.exec("INSERT INTO article VALUES (1, 'タイトル', 'めも本文')")
    @article = Article.new
  end

  def test_article_latest_id
    assert_equal 1, @article.latest_id
  end

  def test_article_list
    result = [{ :id => '1', :title => 'タイトル', :content => 'めも本文' }]
    assert_equal result, @article.list
  end

  def test_article_create
    @article.create('たいとる', '本文本文')
    result = [{ :id => '1', :title => 'タイトル', :content => 'めも本文' }, { :id => '2', :title => 'たいとる', :content => '本文本文' }]
    assert_equal result, @article.list
  end

  def test_article_get
    id = 1
    get_article = @article.get(@article.list, id)
    assert_equal get_article[:id].to_i, 1
    assert_equal get_article[:title], 'タイトル'
    assert_equal get_article[:content], 'めも本文'
  end

  def test_article_drop
    id = 1
    @article.drop(id)
    assert_equal [], @article.get(@article.list, id)
  end

  def test_article_edit
    id = 1
    title = 'メモ修正'
    content = 'メモ本文修正'
    @article.edit(id, title, content)
    get_article = @article.get(@article.list, id)
    assert_equal get_article[:id].to_i, 1
    assert_equal get_article[:title], 'メモ修正'
    assert_equal get_article[:content], 'メモ本文修正'
  end

  def test_article_not_duplicate_id
    @article.create('タイトル', '本文')
    @article.create('タイトル2', '本文2')
    @article.drop(2)
    @article.create('タイトル3', '本文3')
    assert_equal 4, @article.latest_id
  end
end
