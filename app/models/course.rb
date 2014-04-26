require 'active_record'
class Course < ActiveRecord::Base
has_many :Unit , inverse_of: :course
end
