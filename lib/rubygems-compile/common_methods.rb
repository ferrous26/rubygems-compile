module Gem

  module CompileMethods

    def gems_list
      installed_gems = Gem.source_index.all_gems

      gem_names = if options[:all] then
                    installed_gems.map { |_, spec| spec.name }
                  else
                    get_all_gem_names
                  end

      gem_names.map do |gem|
        candidates = Gem.source_index.find_name(gem)

        if candidates.empty?
          alert_error "#{gem} is not installed. Skipping."
          next
        end

        candidates << dependencies_for(*candidates) unless options[:ignore]
        candidates
      end.flatten.uniq
    end

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
