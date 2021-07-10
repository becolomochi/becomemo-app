# frozen_string_literal: true

require 'minitest/autorun'
require './app'

class ArticleTest < Minitest::Test
  def setup
    @connect = PG.connect(dbname: 'becomemo')
    @connect.exec('DELETE FROM Article')
    @connect.exec("INSERT INTO article VALUES (1, 'タイトル', 'めも本文')")
  end

  def test_article_latest_id
    Article.create('たいとる', '本文本文')
    Article.create('たいとる', '本文本文')
    Article.create('たいとる', '本文本文')
    Article.edit(2, 'title', 'content')
    assert_equal 4, Article.latest_id
  end

  def test_article_list
    result = [{ id: '1', title: 'タイトル', content: 'めも本文' }]
    assert_equal result, Article.list
  end

  def test_article_create
    Article.create('たいとる', '本文本文')
    result = [{ id: '2', title: 'たいとる', content: '本文本文' }, { id: '1', title: 'タイトル', content: 'めも本文' }]
    assert_equal result, Article.list
  end

  def test_article_get
    id = 1
    get_article = Article.get(id)
    assert_equal get_article[:id].to_i, 1
    assert_equal get_article[:title], 'タイトル'
    assert_equal get_article[:content], 'めも本文'
  end

  def test_article_drop
    id = 1
    Article.drop(id)
    assert_nil Article.get(id)
  end

  def test_article_edit
    id = 1
    title = 'メモ修正'
    content = 'メモ本文修正'
    Article.edit(id, title, content)
    get_article = Article.get(id)
    assert_equal get_article[:id].to_i, 1
    assert_equal get_article[:title], 'メモ修正'
    assert_equal get_article[:content], 'メモ本文修正'
  end

  def test_article_not_duplicate_id
    Article.create('タイトル', '本文')
    Article.create('タイトル2', '本文2')
    Article.drop(2)
    Article.create('タイトル3', '本文3')
    assert_equal 4, Article.latest_id
  end
end
