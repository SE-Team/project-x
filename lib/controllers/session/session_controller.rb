require 'google/api_client'
require 'yaml'

require './lib/util/util'

class SessionController

  @@users_session_data = Hash.new

  def self.exists?(uuid)
    return @@users_session_data[uuid][:user] ? true : false
  end

  def self.add(uuid, user={})
  	cur_user_hash = get_or_create_user_hash uuid
    cur_user_hash[:user] = user
    return cur_user_hash
  end

  def self.set(uuid, user={})
  	cur_user_hash = get_or_create_user_hash uuid
    cur_user_hash[:user] = user
    return cur_user_hash
  end

  def self.remove(uuid)
    @@users_session_data[uuid] = nil unless uuid == nil
  end

  def self.user_hash(uuid)
  	cur_user_hash = get_or_create_user_hash uuid
    return cur_user_hash
  end

  def self.user(uuid)
  	cur_user_hash = get_or_create_user_hash uuid
    return cur_user_hash[:user]
  end

  def self.users
    @@users_session_data.map{|(uuid, user_map)| user_map[:user] }
  end

  ## if the user doesn't already have a client a new one is created
  def self.get_client(uuid, code="")
  	client = nil
  	cur_user_hash = get_or_create_user_hash uuid
    if cur_user_hash[:client]
    	client = cur_user_hash[:client]
    else
    	client = create_client uuid
    	cur_user_hash[:client] = client
    end
    client.authorization.code = code
    return client
  end

  def self.fetch_access_token!(uuid)
  	client = get_client(uuid)
  	if token_pair(uuid)
  		access_token_pair = token_pair(uuid)
  		client.authorization.update_token!(access_token_pair.to_hash)
  	end
  	if client.authorization.refresh_token && client.authorization.expired?
  		client.authorization.fetch_access_token!
  	end
  	return client.authorization.access_token
  end

  def self.token_pair(uuid)
  	cur_user_hash = get_or_create_user_hash uuid
    if cur_user_hash[:token]
      return cur_user_hash[:token]
    else
      client = get_client(uuid)
      user_token_pair = TokenPair.new
      user_token_pair.update_token!(client.authorization)
      user_token_pair.save
      cur_user_hash[:token] = user_token_pair
      return user_token_pair
    end
  end

  def self.calendar(uuid)
  	calendar = nil
    if @@users_session_data[uuid][:calendar]
    	calendar = @@users_session_data[uuid][:calendar]
    else
    	client = get_client(uuid)
    	calendar = client.discovered_api('calendar', 'v3')
    	@@users_session_data[uuid][:calendar] = calendar
    end
    return calendar
  end

  def self.drive(uuid)
    drive = nil
    if @@users_session_data[uuid][:drive]
      drive = @@users_session_data[uuid][:drive]
    else
      client = get_client(uuid)
      drive = client.discovered_api('drive', 'v2')
      @@users_session_data[uuid][:drive] = drive
    end
    return drive
  end

  private

  def self.get_or_create_user_hash(uuid)
  	if @@users_session_data[uuid]
  		return @@users_session_data[uuid]
  	else
  		@@users_session_data[uuid] = {}
  		return @@users_session_data[uuid]
  	end
  end

  def self.api_config
    @settings ||= (begin
                     settings = YAML::load(File.open('lib/config/config.yml'))
                     settings
    end)
  end

  def self.get_in(hash, keys)
    cur_hash = hash
    keys.each do |kw|
      cur_hash = cur_hash[kw]
    end
    cur_hash
  end

  def self.create_client(uuid, code="")
    config_info = api_config
    client = Google::APIClient.new
    client.authorization.client_id = get_in(config_info, ["google_api", "dev", "client_id"])
    client.authorization.client_secret = get_in(config_info, ["google_api", "dev", "client_secret"])
    client.authorization.scope = get_in(config_info, ["google_api", "dev", "scope"]).join(' ')
    client.authorization.redirect_uri = get_in(config_info, ["google_api", "dev", "registered_redirect_uri"])
    client.authorization.code = code
    return client
  end
end
