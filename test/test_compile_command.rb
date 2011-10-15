class TestCompileCommand < MiniTest::Unit::TestCase

  def setup
    @command = Gem::Commands::CompileCommand.new
  end

  # def test_finds_all_files
  #   # gets into all require dirs
  #   # does not compile test files
  # end
  # def test_recompiles_rbos_if_they_already_exist
  #   # to support use on nightly builds
  # end

  # def test_has_an_option_to_compile_all_installed_gems
  #   # by extension, this is also needed to support nightly build users
  # end

  # def test_refuses_to_compile_itself
  #   # obvious
  # end

  # def test_loads_rubyc_without_warning
  #   # this might not be doable without upstream load guarding; minor issue
  # end

  # # important to test so we don't break rubygems
  # def test_skips_loading_on_older_macruby_versions
  #   # and prints a message
  # end

end
