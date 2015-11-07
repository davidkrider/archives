class ServicesController < ApplicationController
  # GET /services
  # GET /services.xml
  def index
		@years = Service.years
		if !params[:speaker].nil?
			@services = Service.speaker(params[:speaker])
		elsif !params[:year].nil?
			@services = Service.year(params[:year])
			session[:year] = params[:year]
		elsif !session[:year].nil?
			@services = Service.year(session[:year])
		else
			y = @years.last
			@services = Service.year(y)
			session[:year] = y
		end
    #@services = Service.paginate :page => params[:page], :order => 'date_of_service DESC'
		#will_paginate @services, :class => "ui-widget ui-state-highlight ui-corner-all", :style => "margin-top: 20px; padding: 0.7em; text-align: center;" %>
		
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
		if params[:year]
			service_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
			@service = Service.find_by_date_of_service(service_date)
		else
			@service = Service.find(params[:id])
		end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/new
  # GET /services/new.xml
  def new
    @service = Service.new
		@service.ministrations.build
		@speakers = Speaker.all(:include => :salutation, :order => "last_name, first_name")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id])
		@speakers = Speaker.all(:include => :salutation, :order => "last_name, first_name")
  end

  # POST /services
  # POST /services.xml
  def create
    @service = Service.new(params[:service])

    respond_to do |format|
      if @service.save
        flash[:notice] = 'Service was successfully created.'
        format.html { redirect_to(@service) }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.xml
  def update
		params[:service][:existing_ministration_attributes] ||= {}
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
				@service.recordings.each { |r| r.rename }
        flash[:notice] = 'Service was successfully updated.'
        format.html { redirect_to(@service) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.xml  { head :ok }
    end
  end

	def problems
		@services = Service.all(:order => 'date_of_service')
		#@no_speakers = @services.map { |s| s if !s.title.nil? && s.speakers.empty? &&
		#	s.kind_id < 3 && s.title != "N/A" && !s.title.match(/^No Service/) }.compact
		@no_speakers = []
		#@no_titles = @services.map { |s| s if s.title.nil? && !s.speakers.empty? }.compact
		@no_titles = []
		@neither = @services.map { |s| s if s.title.nil? && s.speakers.empty? }.compact
		@off_days = @services.select { |s| s.date_of_service.wday == 1 || ((s.date_of_service.wday == 2 || s.date_of_service.wday == 4)	&& s.date_of_service.year.to_i > 1991) }
	end

	def search
		@speakers = Speaker.all(:include => :salutation)
	end

	def results
		@services = Service.find(:all, :include => :speakers,
			:conditions => "title like '%#{params[:services][:title]}%'",
			:order => "date_of_service")
		unless params[:services][:speaker_id].empty?
			@services = @services.select { |s| s.speaker_ids.include?(
				params[:services][:speaker_id].to_i) }
		end
		unless params[:services][:kind_id].empty?
			@services = @services.select { |s| s.kind_id == 
				params[:services][:kind_id].to_i }.compact
		end
	end
	
	def statistics
		@years = Service.years
	end

end
