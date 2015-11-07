module ServicesHelper

	def add_ministration_link(name)
		link_to_function name do |page|
			page.insert_html :bottom, :ministrations, :partial => 'ministration', :object => Ministration.new
		end
	end
  
end