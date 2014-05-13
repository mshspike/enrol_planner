class StreamUnit < ActiveRecord::Base
  belongs_to :stream, :foreign_key=>:stream_id, :primary_key=> :stream_id, inverse_of: :streamunits
  belongs_to :unit, :foreign_key=> :unit_id, :primary_key=> :unit_id, inverse_of: :Unit
end
