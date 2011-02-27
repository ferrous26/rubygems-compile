require 'helper'

class TestFindFilesToCompile < MiniTest::Unit::TestCase

  def setup
    super
    @test_gem = MiniTest::Mock.new
  end

  def test_strips_test_files
    @test_gem.expect :files, [
      'test/file1', 'test/file2', 'spec/file1', 'spec/file2', 'setup.rb'
                            ]
    @test_gem.expect :test_files, [ 'test/file1', 'spec/file1' ]
    @test_gem.expect :extra_rdoc_files, []

    assert_equal [ 'setup.rb' ], @command.find_files_to_compile(@test_gem)
  end

  def test_strips_non_ruby_source_files
    @test_gem.expect :files, [
      'README.rdoc', 'LICENSE.txt', 'Gemfile', 'setup.rb'
                            ]
    @test_gem.expect :test_files, []
    @test_gem.expect :extra_rdoc_files, [
      'README.rdoc', 'LICENSE.txt', 'Gemfile'
                                       ]
    assert_equal [ 'setup.rb' ], @command.find_files_to_compile(@test_gem)
  end

  def test_returns_array_of_files
    source_files = [
      'lib/gem.rb', 'lib/gem/helper.rb', 'ext/help/extconf.rb', 'setup.rb'
                   ]
    @test_gem.expect :files, source_files
    @test_gem.expect :test_files, []
    @test_gem.expect :extra_rdoc_files, []

    ret = @command.find_files_to_compile @test_gem
    assert_instance_of Array, ret
    assert_equal source_files, ret
  end

end
