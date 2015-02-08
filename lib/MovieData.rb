require "./lib/Database.rb"
require "./lib/MovieTest.rb"
require 'ostruct'

##
# Calculate the similarity between users and make predication for one user on a certain movie
#
class MovieData
	##
	# Create a database and load training and testing data into it
	#
	def initialize(dir,filename=nil)
		@db=DataBase.new(dir,filename)
		@movie_result=MovieTest.new(@db)
		@timmer=0
		@predict_call_count=0
	end
	##
	#return the rate user u give to movie m
	#
	def rating(u,m)
		result=@db.get_rate(u,m,:base)
		if result
			return result.to_i
		else
			return 0
		end
	end
	
	##
	# Get the average rating of the k user who has watched this movie 
	# and has highest similarity with  user u.
	#
	def predict(u,m,k=25) 
		t1=Time.now
		@predict_call_count+=1
		candidate_list=[]
		if viewers(m).empty?
			return rand(5) #if a movie has no viewer then return a random score
		end
		viewers(m).each do |viewer|
			similarity_score=similarity(viewer,u)
			find_and_replace(candidate_list,viewer,similarity_score,k)
		end
		result=0
		candidate_list.each do |element|
			result+=rating(element.user,m)
		end
		t2=Time.now
		@timmer+=t2-t1
		return result/Float(candidate_list.length)
	end
	##
	# If the list length is lower than K, insert the user 
	# Replace the lowest score item in list if its similarity score is lower than the user we want to insert.
	#
	def find_and_replace(list,user,score,k)
		to_insert=OpenStruct.new(:user=>user,:score=>score)
		if list.length<k
			list.push(to_insert)
		else
			minium=list[0]
			list.each_index do |i|
				if list[i].score<to_insert.score #swap the insert one with current element
					temp=list[i]
					list[i]=to_insert
					to_insert=temp
				end
			end
		end
	end
	##
	# Show the average time cost of predict operation
	#
	def average_predict_time
		return @timmer/Float(@predict_call_count)
	end
	##
	# Calculate the similarity between 2 users
	#
	def similarity(u1,u2)
		similarity=0
		watched_u1=@db.get_movie_by_user(u1,:base)
		watched_u2=@db.get_movie_by_user(u2,:base)
		watched_u1.each do |movie,rate|
			if watched_u2.has_key?(movie)
				similarity+=5-(watched_u2[movie].to_i-watched_u1[movie].to_i).abs
			end
		end
		return similarity
	end
	
	##
	# Return all movies viewed by the user
	#
	def movies(u)
		movie_array=[]
		@db.get_movie_by_user(u,:base).each do |movie,rate|
			movie_array.push(movie)
		end
		return movie_array
	end
	
	##
	# Return all the viewers of the movie
	#
	def viewers(m)		
		viewer_array=[]
		if @db.get_user_by_movie(m,:base)==nil
			return viewer_array
		end
		@db.get_user_by_movie(m,:base).each do|user,rate|
			viewer_array.push(user)
		end
		return viewer_array
	end
	##
	# Run the test! Return MovieTest
	#
	def run_test(k=nil)
		count=0
		test_result_db=@db.get_database()#get test datebase with user as key in default 
		mv_test=MovieTest.new(test_result_db)
		test_result_db.each do |user,movie_hash|
			movie_hash.each do|movie,rate|
				if k and k<count
					return mv_test
				end
				predict_result=predict(user,movie)
				real=rate
				count+=1
				puts count
				mv_test.add_entry(user,movie,real,predict_result)
			end
		end
		return mv_test
	end
end








