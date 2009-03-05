# -*- coding: utf-8 -*-
require 'test_helper'

class StaticGeneratorTest < ActiveSupport::TestCase
  include Webrat::Matchers
  include ERB::Util

  attr_accessor :response_body
  def setup
    @response_body = nil
    @m17n_cms_output_dir_env = ENV["M17N_CMS_OUTPUT_DIR"]
    ENV["M17N_CMS_OUTPUT_DIR"] = nil
    FileUtils.rm_rf(StaticGenerator.output_dir)
  end

  def teardown
    ENV["M17N_CMS_OUTPUT_DIR"] = @m17n_cms_output_dir_env
  end

  def test_output_dir
    assert_equal(File.join(RAILS_ROOT, "public", "static"),
                 StaticGenerator.output_dir)
    ENV["M17N_CMS_OUTPUT_DIR"] = "/tmp/static"
    assert_equal("/tmp/static", StaticGenerator.output_dir)
  end

  def test_generate
    Dir.chdir(RAILS_ROOT) do
      system("rake -s static:generate")
    end
    index_html = File.join(StaticGenerator.output_dir, "index.html")
    @response_body = File.read(index_html)
    index_ja = contents(:index_ja)

    assert_contain(Site.default.title)
    assert_have_selector("div#main")
    assert_select("div#main", 1) do |main|
      assert_equal(<<-EOH.chomp, main[0].to_s)
<div id="main">
<h2>ようこそ</h2>
<p>はじめまして</p>
<a href="introduction-ja.html">紹介</a>

</div>
EOH
    end

    index = pages(:index)
    not_available_contents = index.sorted_contents - index.sorted_available_contents
    not_available_language = not_available_contents[0].language
    not_available_html = File.join(StaticGenerator.output_dir,
                                   "index.html.#{not_available_language}")
    assert_false(File.exist?(not_available_html))
  end

  def response_from_page_or_rjs
    html_document.root
  end

  def html_document
    @html_document ||= HTML::Document.new(@response_body, false, false)
  end
end
