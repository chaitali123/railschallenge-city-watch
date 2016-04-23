class Responder < ActiveRecord::Base
	self.inheritance_column = nil

  validates_presence_of :name, :type, :capacity
  validates_uniqueness_of :name
  validates :capacity, inclusion: {in: (1..5).to_a}

  def to_json
  	{
  		:emergency_code=> self.emergency_code,
  		:type=> self.type,
  		:name => self.name,
  		:capacity=> self.capacity,
  		:on_duty => self.on_duty
  	}
  end
end
