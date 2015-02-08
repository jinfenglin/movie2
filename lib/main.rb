require './lib/MovieData.rb'

md=MovieData.new('ml-100k',:u1)
mv_test=md.run_test
output_predict=File.open('./output/output_predict.txt','w')
output_static=File.open('./output/output_static.txt','w')
result_list=mv_test.to_a
result_list.each  do |list|
	output_predict.write(list)
	output_predict.puts( )
end
output_static.puts("Mean="+mv_test.mean.to_s)
output_static.puts("RMS="+mv_test.rms.to_s)
output_static.puts("STDDEV="+mv_test.stddev.to_s)
output_static.puts("Average predict time cost="+md.average_predict_time.to_s)


output_predict.close()
output_static.close()