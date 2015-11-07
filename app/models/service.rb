class Service < ActiveRecord::Base
	belongs_to :kind
	has_many :ministrations
	has_many :speakers, :through => :ministrations
	has_many :recordings, :dependent => :destroy

	cattr_reader :per_page
  @@per_page = 50

	scope :year, lambda { |y| { :conditions => "YEAR(date_of_service) = #{y}",
 		:order => "date_of_service", :include => [ :recordings, { :speakers => :salutation } ] } }

	scope :speaker, lambda { |s| { :conditions => "speakers.id = #{s}",
 		:order => "date_of_service", :include => [ :recordings, { :speakers => :salutation } ] } }

	def self.years
		#ys = []
		#Service.all.collect { |s| ys << s.date_of_service.year }
		#ys.uniq!
		ys = (1984..2011).to_a
	end

	def self.multiple(y)
		ms = []
		Service.find(:all, :conditions => "YEAR(date_of_service) = #{y}").collect do |s|
		 	ms << s if s.recordings.count > 1
		end
		ms.count
	end

end
