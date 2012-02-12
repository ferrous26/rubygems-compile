module Gem

  module CompileMethods

    def execution_list
      gems_list.map do |gem|
        candidates = Gem.source_index.find_name(gem, options[:version])

        if candidates.empty?
          alert_error "#{gem} is not installed. Skipping."
          next
        end

        candidates << dependencies_for(*candidates) unless options[:ignore]
        candidates
    end
    gems.flatten!
    gems.uniq!
    gems.delete_if { |spec| spec.name == 'rubygems-compile' }
    gems
  end

    def gems_list
      # @todo Gem.source_index is going away...
      installed_gems = Gem.source_index.all_gems
      if options[:all] then
        installed_gems.map { |_, spec| spec.name }
      else
        get_all_gem_names
      end
    end

    def dependencies_for *specs
      specs.map { |spec|
        spec.runtime_dependencies.map { |dep|
          deps = Gem.source_index.find_name(dep.name,dep.requirement)
          deps + dependencies_for(*deps)
        }
      }
    end

  end

end
