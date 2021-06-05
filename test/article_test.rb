# frozen_string_literal: true
require 'minitest/autorun'
require './app'

class ArticleTest < Minitest::Test
  def test_sample
    assert_equal 'RUBY', 'ruby'.upcase
  end

  def test_exist_datafile
    filename = 'articles.json'
    assert_equal true, File.exist?(filename)
  end
end
