class SessionController

	@@users = Hash.new

	def self.add(uuid, user)
		@@users[uuid] = user
	end

	def self.remove(uuid)
		@@users[uuid] = nil unless uuid == nil
	end

	## only return the user from the map is the uuid is authentic
	def self.get(uuid)
		@@users[uuid]
	end

	def self.users
		@@users
	end
end