class Status < ActiveRecord::Base
	has_many :recordings

  def to_s
    designation
  end
end
