class DataBase  
	def initialize(dir_path,file_name=nil )
       #.test date stored by using user_id as key and using movie_id as key 
       @test_data_user_key={}
       @test_data_movie_key={}
       #.base date stored by using user_id as key and using movie_id as key
       @base_data_user_key={}
       @base_data_movie_key={}
       
       load_data(dir_path,file_name)
       @user_amount_base=get_amount(@base_data_user_key)
       @movie_amount_base=get_amount(@base_data_movie_key)
       @user_amount_test=get_amount(@test_data_user_key)
       @movie_amount_test=get_amount(@test_data_movie_key)
    end
    def load_data(dir_path,file_name=nil)
		if file_name
          base='./'+dir_path+'/'+file_name.to_s+'.base'
          test='./'+dir_path+'/'+file_name.to_s+'.test'
          base_file=open(base)
          test_file=open(test)
          build_database(base_file,@base_data_user_key,@base_data_movie_key)
          build_database(test_file,@test_data_user_key,@test_data_movie_key)
        else
          path='./'+dir_path+'/u.data'
          file=open(path)
          build_database(file,@base_data)
        end
    end
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
    def get_amount(database)
   		return database.length
   	end

    def add_entry(database,first_key,second_key,value)#add an entry to database.
   		if database.has_key? first_key   #nested dict
				database[first_key][second_key]=value
			else
				database[first_key]={second_key=>value} #build new dict to hold movie:rate_score
			end
    end
    def get_movie_by_user(user, database_type)#user should be string not int
    	case database_type
    	when :test
    		return @test_data_movie_key[user]
    	when :base
    		return @base_data_movie_key[user]
    	else：
    		raise "Unknown database type"
    	end
    end
    def get_user_by_movie(movie,database_type)# :base or :test this function will return a hash
    	case database_type
    	when :test
    		return @test_data_user_key[movie]
    	when :base
    		return @base_data_user_key[movie]
    	else：
    		raise "Unknown database type"
    	end
    end
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

class MovieTest
end

md=DataBase.new('ml-100k',:u1)

end

