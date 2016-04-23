class Emergency < ActiveRecord::Base
	validates_presence_of :code, :fire_severity, :police_severity, :medical_severity
	validates :fire_severity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
	validates :police_severity, numericality: { only_integer: true, greater_than_or_equal_to: 0  }
	validates :medical_severity, numericality: { only_integer: true, greater_than_or_equal_to: 0  }
	validates_uniqueness_of :code

	def self.full_responses
		[Responder.count, Emergency.count]
	end

	def self.get_servity(params)
		fire_severity  = Responder.where(type: "Fire").select(:name,:capacity)
		police_severity = Responder.where(type: "Police").select(:name,:capacity)
		medical_severity = Responder.where(type: "Medical").select(:name,:capacity)

		max_fire_servity = fire_severity.pluck(:capacity).inject(:+)
		max_police_servity = police_severity.pluck(:capacity).inject(:+)
		max_medical_servity = medical_severity.pluck(:capacity).inject(:+)

		if params[:fire_severity].present?
			fire_code = params[:fire_severity].to_i > max_fire_servity ? fire_severity.pluck("name") : fire_severity.where("capacity = ?", params[:fire_severity]).pluck("name")
			# possible_combo = self.get_closest_combination(fire_severity.pluck("capacity"),params[:fire_severity])
			# fire_code = fire_severity.where(capacity: possible_combo).pluck("name") if fire_code.blank? 
		end

		if params[:police_severity].present?
			police_code = params[:police_severity].to_i > max_police_servity ? police_severity.pluck("name") : police_severity.where("capacity = ?", params[:police_severity]).pluck("name")
			# possible_combo = self.get_closest_combination(police_severity.pluck("capacity"),params[:police_severity])
			# police_code = police_severity.where(capacity: possible_combo).pluck("name") if police_code.blank? 
		end

		if params[:medical_severity].present?
			medical_code = params[:medical_severity].to_i > medical_severity ? medical_severity.pluck("name") : medical_severity.where("capacity = ? ",params[:medical_severity]) .pluck("name")
			# possible_combo = self.get_closest_combination(medical_severity.pluck("capacity"),params[:medical_severity])
			# medical_code = medical_severity.where(capacity: possible_combo).pluck("name") if medical_code.blank? 
		end
		[fire_code,police_code,medical_code]
	end

	def self.get_closest_combination(capacity_arr,closest_no)
		possible_combo = {}
		capacity_arr_combo = []
		(0..capacity_arr.length).each do |element|
			capacity_arr_combo = capacity_arr_combo + capacity_arr.combination(element).to_a
		end
		capacity_arr_combo = capacity_arr_combo.compact
		capacity_arr_combo = capacity_arr_combo.reject{|new_arr| new_arr.empty?}
		capacity_arr_combo.each do |new_arr|
			possible_combo.merge!(new_arr.inject(:+)=>new_arr)
		end
	
		possible_combo[closest_no]
	end
end
