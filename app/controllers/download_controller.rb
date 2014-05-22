class DownloadController < ApplicationController 
  def index
  end

  def pdf
  	
  	require "test"
   

  	#send_file Rails.root.join('private', 'test.pdf'), :type=>"application/pdf", :x_sendfile=>true
  end

  def csv
  	send_file Rails.root.join('private', 'test.csv'), :type=>"application/csv", :x_sendfile=>true
  end
end
