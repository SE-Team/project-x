module Util
	def random_string(len)
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		str = ""
		1.upto(len) { |i| str << chars[rand(chars.size-1)] }
		return str
	end

	def get_in(hash, ker_arr)
		cur_hash = hash
		key_arr.each do |kw|
			cur_hash = cur_hash[kw]
		end
		cur_hash
	end
end