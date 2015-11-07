class Salutation < ActiveRecord::Base
	has_many :speakers

  def to_s
    designation
  end
end
