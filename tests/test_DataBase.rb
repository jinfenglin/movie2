require "./lib/Database.rb"
require "test/unit"

class TestDataBase< Test::Unit::TestCase

  def test_Database
  	assert_nothing_raised do
  	    db_default=DataBase.new('ml-100k')
  		db_splict=DataBase.new('ml-100k',:u1)
  	end
  end
  def test_get_id
  	  db=DataBase.new('test_data',:my_test)
  	  assert_equal(db.get_movie_by_user('1',:base),{'1'=>'3','2'=>'5'})
  	  assert_equal(db.get_movie_by_user('1',:test),{'2'=>'3'})
  	  
  	  assert_equal(db.get_user_by_movie('1',:base),{'1'=>'3','2'=>'4'})
  	  assert_equal(db.get_user_by_movie('1',:test),nil)
  end
  def test_get_rate
  	  db=DataBase.new('test_data',:my_test)
  	  assert_equal(db.get_rate('1','1',:base),'3')
  	  assert_equal(db.get_rate('1','2',:test),'3')
  end
end
