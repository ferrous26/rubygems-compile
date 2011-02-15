Gem.post_install do |gem|

  spec  = gem.spec
  files = spec.files - spec.test_files - spec.extra_rdoc_files

  files.each do |file|
    next unless file.match /\.rb$/
    puts "Compiling #{file} to #{file}o"
  end

end
