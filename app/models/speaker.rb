class Speaker < ActiveRecord::Base
	belongs_to :salutation
	has_many :ministrations, :dependent => :destroy
	has_many :services, :through => :ministrations

	validates_uniqueness_of :first_name, :scope => :last_name

	cattr_reader :per_page
  @@per_page = 25

	def full_name
		"#{first_name} #{last_name}"
	end

	def proper_name
		"#{salutation.designation} #{first_name} #{last_name}"
	end

	def sortable_name
		"#{last_name}, #{salutation.designation} #{first_name}"
	end
	
end
