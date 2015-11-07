module ApplicationHelper

	def preferred_date_format(date)
		date.strftime("%a, %b %e, %Y")
	end

end
