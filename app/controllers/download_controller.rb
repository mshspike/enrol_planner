class DownloadController < ApplicationController
  def index
  end

  def pdf
  	send_file Rails.root.join('private', 'test.pdf'), :type=>"application/zip", :x_sendfile=>true
  end

  def csv
  	send_file Rails.root.join('private', 'test.csv'), :type=>"application/zip", :x_sendfile=>true
  end
end
