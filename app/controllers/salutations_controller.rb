class SalutationsController < ApplicationController
  # GET /salutations
  # GET /salutations.xml
  def index
    @salutations = Salutation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @salutations }
    end
  end

  # GET /salutations/1
  # GET /salutations/1.xml
  def show
    @salutation = Salutation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @salutation }
    end
  end

  # GET /salutations/new
  # GET /salutations/new.xml
  def new
    @salutation = Salutation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @salutation }
    end
  end

  # GET /salutations/1/edit
  def edit
    @salutation = Salutation.find(params[:id])
  end

  # POST /salutations
  # POST /salutations.xml
  def create
    @salutation = Salutation.new(params[:salutation])

    respond_to do |format|
      if @salutation.save
        flash[:notice] = 'Salutation was successfully created.'
        format.html { redirect_to(@salutation) }
        format.xml  { render :xml => @salutation, :status => :created, :location => @salutation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @salutation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /salutations/1
  # PUT /salutations/1.xml
  def update
    @salutation = Salutation.find(params[:id])

    respond_to do |format|
      if @salutation.update_attributes(params[:salutation])
        flash[:notice] = 'Salutation was successfully updated.'
        format.html { redirect_to(@salutation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @salutation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /salutations/1
  # DELETE /salutations/1.xml
  def destroy
    @salutation = Salutation.find(params[:id])
    @salutation.destroy

    respond_to do |format|
      format.html { redirect_to(salutations_url) }
      format.xml  { head :ok }
    end
  end
end
