# class CommonMethodsTester
#   include Gem::CompileMethods

#   class Gem
#     class << self
#       def source_index
#         GemList.new
#       end
#     end
#   end

# end

# class GemList
#   def all_gems
#     ['the', 'answer', 'to', 'life', 'the', 'universe', 'and', 'everything']
#   end
# end

# class TestCommonMethods < MiniTest::Unit::TestCase

#   def modul
#     @@modul ||= CommonMethodsTester.new
#   end

#   def test_execution_list
#   end

#   def test_gems_list
#     def modul.options
#       { all: true }
#     end
#     assert_equal GemList.new.all_gems, modul.gems_list
#   end

#   def test_dependencies_for
#   end

# end
