module Gem::CompileMethods
if Gem::VERSION.to_f < 1.8

  def execution_list
    return all_gemspecs if options[:all]

    specs = get_all_gem_names.map do |gem|
      candidates = Gem.source_index.find_name(gem, options[:version])

      if candidates.empty?
        alert_error "#{gem} is not installed. Skipping."
        next
      end

      candidates << dependencies_for(candidates) unless options[:ignore]
      candidates
    end
    specs.flatten!
    specs.uniq!
    specs.delete_if { |spec| spec.name == 'rubygems-compile' }
    specs
  end


  private

  def all_gemspecs
    specs = Gem.source_index.all_gems.map(&:last)
    specs.select { |spec| spec.name != 'rubygems-compile' }
  end

  def dependencies_for specs
    specs.map { |spec|
      spec.runtime_dependencies.map { |dep|
        deps = Gem.source_index.find_name(dep.name, dep.requirement)
        deps + dependencies_for(*deps)
      }
    }
  end

else

  def execution_list
    return all_gemspecs if options[:all]

    specs = get_all_gem_names.map { |gem|
      names = Gem::Specification.find_all_by_name(gem, options[:version])
      names << dependencies_for specs unless options[:ignore]
    }
    specs.flatten!
    specs.uniq!
    specs.delete_if { |spec| spec.name == 'rubygems_compile' }
    specs
  end


  private

  def all_gemspecs
    Gem::Specification.map(&:name).select { |name| name != 'rubygems-compile' }
  end

  def dependencies_for specs
    specs.map { |spec|
      spec.runtime_dependencies.map { |dep|
        deps = Gem::Specification.find_all_by_name(dep.name, dep.requirement)
        deps + dependencies_for(*deps)
      }
    }
  end

end
end
