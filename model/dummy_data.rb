require './model/user'
require './model/Admin'

if User.all.count == 0
	superman = User.first_or_create(user_name: "superman", password: "pass", email: "superman@superman.com")
	batman = User.first_or_create(user_name: "batman", password: "pass", email: "batman@batman.com")
	spiderman = User.first_or_create(user_name: "spiderman", password: "pass", email: "spiderman@spiderman.com")
	joker = User.first_or_create(user_name: "joker", password: "pass", email: "joker@joker.com")
	bane = User.first_or_create(user_name: "bane", password: "pass", email: "bane@bane.com")
	lex_luther = User.first_or_create(user_name: "lex-luther", password: "pass", email: "lex-luther@lex-luther.com")
end
if Admin.all.count == 0
	admin = Admin.first_or_create(user_name: "admin", password: "*Project-X*")
end
