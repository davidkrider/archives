class Kind < ActiveRecord::Base
	has_many :services

  def to_s
    designation
  end
end
