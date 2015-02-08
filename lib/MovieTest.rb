require 'ostruct'
class MovieTest
	def initialize(database)#get the gold database from MovieData
		@predict_result={}
		@gold=database
		@mean_value=nil
		@dev_value=nil
		@rms_value=nil
	end
	
	##
	# Add one entry into our result hash
	#
	def add_entry(user,movie,real,pred)
		key=OpenStruct.new(:user=>user,:movie=>movie)
		@predict_result[key]=[real,pred]
	end
	##
	# Calculate stddev
	#
	def stddev
		mean_value=mean
		square_sum=0
		num=@predict_result.length
		@predict_result.each do |entry|
			pred=get_attribute(entry,:predict)
			square_sum+=(pred-mean)**2
		end
		return Math.sqrt(square_sum/Float(num))
	end
	
	##
	# Calculate rms
	#
	def rms
		square_sum=0
		num=@predict_result.length
		@predict_result.each do |entry|
			square_sum+=get_attribute(entry,:predict)**2
		end
		return Math.sqrt(square_sum/Float(num))
	end
	
	##
	# Transfer the result hash into list.
	#
	def to_a
		result_list=[]
		@predict_result.each do |entry|
			result_list.push(entry_to_array(entry))
		end
		return result_list
	end
	
	##
	# Calculate mean
	#
	def mean
		sum=0
		num=@predict_result.length
		@predict_result.each do |entry|
			sum+=attr_differ(entry,:real,:predict).abs
		end
		return sum/Float(num)
	end
	
	##
	# Get an entry according to the user and movie
	#
	def get_entry(user,movie)
		key=OpenStruct(:user=>user,:movie=>movie)
		return predict_result[key]
	end
	
	##
	# Transfer a single entry into a list, in the required format
	#
	def entry_to_array(entry)
		user=get_attribute(entry,:user)
		movie=get_attribute(entry,:movie)
		real=get_attribute(entry,:real)
		pred=get_attribute(entry,:predict)
		return[user,movie,real,pred]
	end
	
	##
	#  Get a required attribute from the entry
	#
	def get_attribute(entry,attr=nil)
		case attr
		when :user
			return entry[0].user
		when :movie
			return entry[0].movie
		when :real
			return entry[1][0].to_f
		when :predict
			return entry[1][1].to_f
		else
			return entry
		end
	end
	
	##
	# Get the absolute difference of 2 attributes, the two should be able to applied to '-'
	# operatio
	def attr_differ(entry,attr1,attr2)
		return get_attribute(entry,attr1)-get_attribute(entry,attr2)
	end
end