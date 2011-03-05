module Gem
module Compile
module Methods

  def get_specs_for_gems gem_names # :nodoc:
    gem_names.flatten.map { |gem|
      Gem.source_index.find_name gem
    }.flatten.compact
  end

  def find_files_to_compile gem # :nodoc:
    files = gem.files - gem.test_files - gem.extra_rdoc_files
    files = files.reject do |file| file.match /^(?:test|spec)/ end
    # this cuts out the .rb.data file in the mime-types gem
    files.select do |file| file.match /\.rb$/ end
  end

end
end
end
