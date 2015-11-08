class Recording < ActiveRecord::Base

	belongs_to :service
	belongs_to :status

	PROCESSED = "/data/Digitizing/Processed/"
	EXTERNAL = "/data/Digitizing/External/"

	scope :year, lambda { |y| { :conditions => "YEAR(services.date_of_service) = #{y}",
 		:order => "services.date_of_service", :include => :service } }

	def format
		filename.slice(/[^.]*$/).upcase
	end

	def linky
		"/archives/#{service.date_of_service.year}/#{filename}"
	end

	def ploty
		"/images/#{service.date_of_service.year}/#{plot}"
	end

	def name
		name = service.date_of_service.strftime('%d_%b_%Y')
		if service.speakers.count > 1
			name += '-' + 'Multiple Speakers'
		elsif service.speakers.count == 1
			name += '-' + service.speakers[0].full_name
		else
			name += '-' + 'No Speaker'
		end
		unless service.title.nil? || service.title.empty?
			name += '-' + service.title
		else
			name += '-' + 'No Title'
		end
		name = date if name.nil?
		name.gsub!("?", "")
		name.gsub!("'", "")
		name.gsub!("\/", " ")
		name.gsub!("\\", " ")
		name.gsub!("&", "and")
		name.gsub!(";", ",")
		name.gsub!(":", ",")
		name.gsub!("(", "")
		name.gsub!(")", "")
		name.gsub!("\.", "")
		name.gsub!("  ", " ")
		name.gsub!(" - ", ", ")
		name.gsub!(" ", "_")
	end

	def rename
		index = nil
		# The underscore is for getting called from post_process.rb
		if filename[-6, 2] == "-1" || filename[-6, 2] == "_1"
			index = 1
		elsif filename[-6, 2] == "-2" || filename[-6, 2] == "_2"
			index = 2
		elsif filename[-6, 2] == "-3" || filename[-6, 2] == "_3"
			index = 3
		end
		new_name = name
		new_name = new_name + "-" + index.to_s unless index.nil?
		old_name = filename.split('.mp3')[0]
		File.rename(PROCESSED + service.date_of_service.year.to_s + "/" + filename,
			PROCESSED + service.date_of_service.year.to_s + "/" + new_name + ".mp3")
		File.rename(PROCESSED + service.date_of_service.year.to_s + "/" + plot,
			PROCESSED + service.date_of_service.year.to_s + "/" + new_name + ".png")
		if service.date_of_service.year < 2007
			File.rename(EXTERNAL + service.date_of_service.year.to_s + "/" + old_name + "-a.flac",
				EXTERNAL + service.date_of_service.year.to_s + "/" + new_name + "-a.flac")
			File.rename(EXTERNAL + service.date_of_service.year.to_s + "/" + old_name + "-b.flac",
				EXTERNAL + service.date_of_service.year.to_s + "/" + new_name + "-b.flac")
		end
		self.filename = new_name + ".mp3"
		self.plot = new_name + ".png"
		save
		tag
	end

	def tag
		speaker = nil
		if service.speakers.count > 1
			speaker = 'Multiple Speakers'
		elsif service.speakers.count == 1
			speaker = service.speakers[0].full_name
		else
			speaker = 'No Speaker'
		end
		index = nil
		if filename[-6, 2] == "-1" || filename[-6, 2] == "_1"
			index = 1
		elsif filename[-6, 2] == "-2" || filename[-6, 2] == "_2"
			index = 2
		elsif filename[-6, 2] == "-3" || filename[-6, 2] == "_3"
			index = 3
		end
		year = service.date_of_service.year.to_s
		fullname = PROCESSED + year + "/" + filename
#		require 'taglib'
#		TagLib::File.new(fullname) do |f|
#			t = f.id3v2_tag
#			t.title = service.title
#			t.artist = speaker.full_name
#			t.year = service.date_of_service.year
#			t.track = index
#			#ps = f.audio_properties
#			#ps.length
#			puts t.to_yaml
#			f.save
#		end
#		Usage: id3tag [OPTIONS]... [FILES]...
#			   -h         --help            Print help and exit
#			   -V         --version         Print version and exit
#	  	   -1         --v1tag           Render only the id3v1 tag (default=off)
#				 -2         --v2tag           Render only the id3v2 tag (default=off)
#				 -aSTRING   --artist=STRING   Set the artist information
#				 -ASTRING   --album=STRING    Set the album title information
#				 -sSTRING   --song=STRING     Set the title information
#				 -cSTRING   --comment=STRING  Set the comment information
#				 -CSTRING   --desc=STRING     Set the comment description
#				 -ySTRING   --year=STRING     Set the year
#				 -tSTRING   --track=STRING    Set the track number
#				 -TSTRING   --total=STRING    Set the total number of tracks
#				 -gSHORT    --genre=SHORT     Set the genre
#				 -w         --warning         Turn on warnings (for debugging) (default=off)
#				 -n         --notice          Turn on notices (for debugging) (default=off)
		logger = Logger.new(STDERR)
		logger.info(`id3tag -a "#{speaker}" -s "#{service.title}" -t "#{index}" -y "#{year}" "#{fullname}"`)
	end

end
