require 'fileutils'

desc 'Update the vendored neo4j'
task :update, [:path] do |t,args|
  path = Pathname.new(args[:path])
  raise ArgumentError.new("Expecting path to a tar.gz") unless path.basename.to_s =~ /tar\.gz/

  puts "tar -xzf #{args[:path]} -C #{ROOT}"
  system("tar -xzf #{args[:path]} -C #{ROOT}")

  unpacked_folder_name = path.basename.to_s.gsub(/\.tar\.gz/,'').gsub("-unix","")

  FileUtils.mv    ROOT.join(unpacked_folder_name), ROOT.join("neo4j")
  FileUtils.rm_rf ROOT.join("neo4j/data")
  FileUtils.rm_rf ROOT.join("neo4j/examples")
  FileUtils.rm_rf ROOT.join("neo4j/doc")
  FileUtils.rm_rf ROOT.join("neo4j/bin")
end