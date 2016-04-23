class Emergency < ActiveRecord::Base
	validates_presence_of :code, :fire_severity, :police_severity, :medical_severity
	validates :fire_severity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
	validates :police_severity, numericality: { only_integer: true, greater_than_or_equal_to: 0  }
	validates :medical_severity, numericality: { only_integer: true, greater_than_or_equal_to: 0  }
	validates_uniqueness_of :code

	def self.full_responses
		[1, Emergency.count]
	end
end
