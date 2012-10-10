module Util
	def random_string(len)
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		str = ""
		1.upto(len) { |i| str << chars[rand(chars.size-1)] }
		return str
	end

	def get_in(hash, keys)
		cur_hash = hash
		keys.each do |kw|
			cur_hash = cur_hash[kw]
		end
		cur_hash
	end

	def filter_by_sequence(coll, keys, opts)
		type = opts[:type] || :filter
		if coll.class == Hash
			if type == :filter
				return coll.reject{|(k, v)| !keys.include? k}
			else
				return coll.reject{|(k, v)| keys.include? k}
			end
		else
			if type == :filter
				return coll.reject{|v| !keys.include? v}
			else
				return coll.reject{|(k, v)| keys.include? k}
			end
		end
	end

	def filter(coll, keys)
		return filter_by_sequence(coll, keys, {type: :filter})
	end

	def sift(coll, keys)
		return filter_by_sequence(coll, keys, {type: :sift})
	end
end