class Ministration < ActiveRecord::Base
	belongs_to :service
	belongs_to :speaker
end
