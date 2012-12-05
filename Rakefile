require 'data_mapper'
# require 'spec/rake/spectask'
require 'yaml'

################################################################################
## DataMapper Tasks ############################################################
################################################################################
task :clean do
	File::delete("./lib/db/base.db")
	puts "Delete base.db"
end

task :init_db do
	puts "setup db"
	load "#{Dir.pwd}/model/dm"
	puts "auto upgrade db"
end

task :init_dummy_data do
	puts "init dummy db data..."
	load "#{Dir.pwd}/model/dummy_data.rb"
end

task :explode do
	puts "Explode db and rebuild with dummy data"
	Rake::Task[:clean]
	Rake::Task[:init_db]
	Rake::Task[:init_dummy_data]
end
################################################################################

################################################################################
## Heroku Tasks ################################################################
################################################################################
task :deploy_local do
	ENV['DEV_MODE'] = true

end

task :deploy_to_heroku do
	ENV['DEV_MODE'] = false
end
################################################################################

################################################################################
## RSpec Rake tasks ############################################################
## Can be run with:
## $ rake spec
## or some more specific spec tasks like
## $ rake spec_util
################################################################################
# Spec::Rake::SpecTask.new(:spec) do |t|
#   t.spec_files = Dir.glob('./lib/spec/**/*_spec.rb')
#   t.spec_opts << '--format specdoc'
# end

# Spec::Rake::SpecTask.new(:spec_util) do |t|
#   t.spec_files = Dir.glob('./lib/spec/lib/util/*_spec.rb')
#   t.spec_opts << '--format specdoc'
# end
################################################################################

################################################################################
################################################################################
task :new_mvc, :name do |t, mvc_name|
	m_name = "./lib/model/" << mvc_name.underscore << ".rb"
	model_file = File.exists?File.new("./lib/")
end
################################################################################

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    return downcase
  end
end

directory "lib/tasks"

task create: "tasks/diagrams.rb" do

end