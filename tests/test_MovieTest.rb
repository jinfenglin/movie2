require "test/unit"
require "./lib/MovieData.rb"
class Test_MovieTest < Test::Unit::TestCase
	def test_mean
		md=MovieData.new('test_data',:my_test_expend)
		mv_test=md.run_test
		answer=(3- md.predict('1','1')).abs + (5- md.predict('1','2')).abs + (4 -md.predict('2','1')).abs + (3 -md.predict('3','2')).abs
		assert_in_delta(mv_test.mean,answer/4.0,0.01)
	end
	def test_rms
		md=MovieData.new('test_data',:my_test_expend)
		mv_test=md.run_test
		answer=md.predict('1','1')**2 + md.predict('1','2')**2 +md.predict('2','1')**2 +md.predict('3','2')**2
		assert_in_delta(mv_test.rms,Math.sqrt(answer/4.0),0.01)
	end
	
	def test_stddev
		md=MovieData.new('test_data',:my_test_expend)
		mv_test=md.run_test
		mean=mv_test.mean
		answer=(md.predict('1','1')-mean)**2 + (md.predict('1','2')-mean)**2 +(md.predict('2','1')-mean)**2 +(md.predict('3','2')-mean)**2
		assert_in_delta(mv_test.stddev,Math.sqrt(answer/4.0),0.01)
	end
end