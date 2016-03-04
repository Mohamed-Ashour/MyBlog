require 'sequel'

task :install_db do
	DB = Sequel.connect(ENV['DATABASE_URL'])
	DB.run("CREATE TABLE blogs (id SERIAL PRIMARY KEY, title TEXT, summary TEXT, content TEXT)")
	puts 'Done!'
end