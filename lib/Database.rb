##
#This class provide a database for regulating the test and train data.
# Four hash table are contained in this class to store the data. Each hash contain another hash as value.
# The four categories are:
# 1.Hash which store test data and use user id as first key, movie id as second key.
# 2.Hash which store test data and use movie id as first key, user id as second key.
# 3.Hash which store training data and use user id as first key, movie id as second key.
# 4.Hash which store training data and use movie id as first key, user id as second key. 
# Database class provide interface for retrieving user, movie or rate. Also could return 
# the four hashes inside the class.
#
class DataBase	
	#Initialize four hashes and load data into them. The parameter require the directory name
	# and the file name without postfix. 
	def initialize(dir_path,file_name=nil)
       @test_data_user_key={}
       @test_data_movie_key={}
       @base_data_user_key={}
       @base_data_movie_key={}
       
       load_data(dir_path,file_name)
       @user_amount_base=get_amount(@base_data_user_key)
       @movie_amount_base=get_amount(@base_data_movie_key)
       @user_amount_test=get_amount(@test_data_user_key)
       @movie_amount_test=get_amount(@test_data_movie_key)
    end
    
    ##
    # return one of the four database according to parameter. 
    # In default, return the hash which stores test date and ordered by user id.
    # The key_type is confine into 2 categories which are all symbols  :user_key and :movie_key
    # database_type are also confined into 2 types, :test | :base 
    # Any mismatch will raise a runtime exception
    def get_database(key_type=:user_key,database_type=:test)
    	if key_type== :user_key and database_type== :test
    		return @test_data_user_key
    	elsif key_type== :movie_key and database_type== :test 
    		return @test_data_movie_key
    	elsif key_type== :user_key and database_type== :base 
    		return @base_data_user_key
    	elsif key_type== :movie_key and database_type== :base 
    		return @base_data_movie_key
    	else
    		raise "wrong parameter"
    	end
    end
    
    ##
    # Load data into database, the base path is hard coded.
    # dir_path design the dir path, file_name indicate the file name without postfix
    # the postfix is constrained to be .base and .test
    #
    def load_data(dir_path,file_name=nil)
    	loca_path='/Users/jinfenglin/Dropbox/cosi105b_jinfenglin/movies-2/'
		if file_name
          base=loca_path+dir_path+'/'+file_name.to_s+'.base'
          test=loca_path+dir_path+'/'+file_name.to_s+'.test'
          base_file=open(base)
          test_file=open(test)
          build_database(base_file,@base_data_user_key,@base_data_movie_key)
          build_database(test_file,@test_data_user_key,@test_data_movie_key)
        else
          path=loca_path+dir_path+'/u.data'
          file=open(path)
          build_database(file,@base_data_user_key,@base_data_movie_key)
        end
    end
    
    ##
    # Add all entries into hashes. The parameters are the file read in
    # Data will be ordered both by user id and movie id and stored in 2 hash table
    #
    def build_database(file, database_user_key,database_movie_key)
        file.each do |line| 
			tokens=line.split("\t")
			user_id=tokens[0]
			movie_id=tokens[1]
			rate_score=tokens[2]
			add_entry(database_user_key,user_id,movie_id,rate_score)
			add_entry(database_movie_key,movie_id,user_id,rate_score)
        end 
    end
    
    ##
    # Return the size of database
    #
    def get_amount(database)
   		return database.length
   	end
   	
   	##
	# Add one entry into database
	#
    def add_entry(database,first_key,second_key,value)#add an entry to database.
   		if database.has_key? first_key   #nested dict
				database[first_key][second_key]=value
			else
				database[first_key]={second_key=>value} #build new dict to hold movie:rate_score
			end
    end
    
    ##
    #Retrive the rate from database
    #
    def get_rate(user,movie,database_type)
    	return get_movie_by_user(user,database_type)[movie]
    end
    
    ##
    # Get all the movies watched by user
    #
    
    def get_movie_by_user(user, database_type)#user should be string not int
    	user=user.to_s
		return chose_database(:user,database_type,user)
    end
    
    ##
    # Get all the viewers of the movie
    #
    def get_user_by_movie(movie,database_type)# :base or :test this function will return a hash
    	movie=movie.to_s
    	return chose_database(:movie,database_type,movie)
    end
    def chose_database(key_type,database_type,key)
    	if database_type== :test and key_type== :movie
    			return @test_data_movie_key[key]
    	elsif database_type== :test and key_type== :user
    			return @test_data_user_key[key]
    	elsif database_type== :base and key_type== :movie
    			return @base_data_movie_key[key]
    	elsif database_type== :base and key_type== :user
    			return @base_data_user_key[key]
    	else
    		raise "Unknown database type"
    	end
    end
    
    ##
    # Show the sizes of all the database
    #
    def print_db_status
    	print "user_amount_base:"
    	puts  @user_amount_base
    	
    	print "movie_amount_base:"
    	puts  @movie_amount_base
    	
    	print "user_amount_test:"
    	puts  @user_amount_test
    	
    	print "movie_amount_test:"
    	puts  @movie_amount_test
    end
    
    ##
    # Show every entry in the database
    # 
    def print_database(database)
		database.each do |key,info_dict| 
			puts 'key:'+key
			info_dict.each do |movie_id,rate|
				print movie_id+' '
				puts rate+' '	
			end
		end
	end   
end
