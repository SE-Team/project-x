require 'dm-core'
require 'yaml'

def 

task :clean do
	File::delete("db/base.db")
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

task :deploy_local do
	ENV['DEV_MODE'] = true

end

task :deploy_to_heroku do
	ENV['DEV_MODE'] = false
end