module Gem
  module SimpleDepList
    private
    def dependencies_for *specs
      specs.map { |spec|
        spec.runtime_dependencies.map { |dep|
          deps = Gem.source_index.find_name(dep.name)
          deps + dependencies_for(*deps)
        }
      }
    end
  end
end
