require './util/util_mock'

describe Util do
	it 'should filter key value pairs out by key seq' do
		keys = [:a, :c]
		hash = {:a => "value_a", :b => "value_b", :c => "value_c", :d => "value_d"}
		util = UtilMock.new
		result = util.filter(hash, keys) == {:a => "value_a", :c => "value_c"}
		result.should be_true
	end

	it 'should sift key vale pairs out by key seq' do
		keys = [:a, :c]
		hash = {:a => "value_a", :b => "value_b", :c => "value_c", :d => "value_d"}
		util = UtilMock.new
		result = util.sift(hash, keys) == {:b => "value_b", :d => "value_d"}
		result.should be_true
	end

	it 'should return a value from a hash based on a sequence of keys' do
		keys = [:a, :b, :c, :d]
		hash =  {:a => {:b => {:c => {:d => "value_d"}}}}
		util = UtilMock.new
		result = util.get_in(hash, keys) == "value_d"
		result.should be_true
	end

	it 'should return a nested hash from a hash based on a sequence of keys' do
		keys = [:a, :b, :c]
		hash =  {:a => {:b => {:c => {:d => "value_d"}}}}
		util = UtilMock.new
		result = util.get_in(hash, keys) == {:d => "value_d"}
		result.should be_true
	end
end