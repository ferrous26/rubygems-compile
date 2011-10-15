class TestGemAnalyzer < MiniTest::Unit::TestCase

  def test_finds_usage_of___FILE__
    assert_raises Gem::Analyzer::Warning do
      Gem::Analyzer.new("__FILE__").parse
    end

    assert_block do
      Gem::Analyzer.new("puts '__FILE__'").parse
    end
  end

end
