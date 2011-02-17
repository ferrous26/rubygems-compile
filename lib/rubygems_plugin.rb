Gem.post_install do |gem|

  spec  = gem.spec
  dir   = gem.gem_home + '/gems/' + spec.name + '-' + spec.version.version

  files = spec.files - spec.test_files - spec.extra_rdoc_files
  files = files.reject { |file| file.match /^(?:test|spec)/ }

  files.each do |file|
    next unless file.match /\.rb$/
    puts "Compiling #{file} to #{file}o"
    file = "#{dir}/#{file}"
    `macrubyc -C '#{file}' -o '#{file}o'`
  end

end
