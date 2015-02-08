require "./lib/MovieData.rb"
require "test/unit"

class TestMovieData< Test::Unit::TestCase
	def test_movie_data
		assert_nothing_raised do
			md=MovieData.new('test_data',:my_test)
		end
	end
	def test_viewers_movies
		md=MovieData.new('test_data',:my_test)
		assert_equal(md.viewers('2'),['1','3'])
		assert_equal(md.movies('1'),['1','2'])
		assert_equal(md.rating('1','2'),5)
		assert_equal(md.rating('1','3'),0)
	end
	def test_similarity_predict
		md=MovieData.new('test_data',:my_test_expend)
		assert_equal(md.similarity('1','2'),4)
		assert_equal(md.similarity('1','3'),3)
		assert_equal(md.similarity('1','1'),10)
		assert_in_delta(md.predict('1','1',3),2.6666,0.001)
		assert_in_delta(md.predict('1','2'),4,0.001)		
	end
end
