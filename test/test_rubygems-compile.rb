require 'helper'

class TestRubygemsCompile < MiniTest::Unit::TestCase

  def setup
    @command = Gem::Commands::CompileCommand.new
  end

  def test_get_specs_for_gem_doesnt_explode_with_bad_gem_names
    assert_empty @command.get_specs_for_gems 'not_a_real_gem'
  end

  def test_get_specs_for_gem_takes_varargs
    assert @command.get_specs_for_gems 'rake', 'not_a_real_gem'
  end

  def test_get_specs_for_gem_returns_gemspecs
    ret = @command.get_specs_for_gems 'rake'
    assert_instance_of Array, ret
    assert_instance_of Gem::Specification, ret.first
  end

end
