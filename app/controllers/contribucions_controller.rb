class ContribucionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :newPage]
  before_action :set_contribucion, only: [:show, :edit, :update, :destroy, :upvote]

  # GET /contribucions
  # GET /contribucions.json
  def index
    @contribucions = Contribucion.all.select{|c| c.url != ""}  
  end
  
  
  # GET /contribucions/newPage
  # GET /contribucions/newPage.json
  def newPage
    @contribucions = Contribucion.all.order("created_at DESC")
    render :partial  => 'index', :locals => { :contribucions => @contribucions } 
  end

  # GET /contribucions/1
  # GET /contribucions/1.json
  def show
  end

  # GET /contribucions/new
  def new
    @contribucion = Contribucion.new
    @contribucion.user_id = current_user.id
  end

  # GET /contribucions/1/edit
  def edit
  end

  # POST /contribucions
  # POST /contribucions.json
  def create
    @contribucion = Contribucion.new(contribucion_params)
    respond_to do |format|
      if @contribucion.save
        format.html { redirect_to @contribucion, notice: 'Contribucion was successfully created.' }
        format.json { render :show, status: :created, location: @contribucion }
      else
        @url = contribucion_params[:url]
        @contribucion = Contribucion.all.select{|c| c.url == @url}  
        format.html { redirect_to @contribucion}
        format.json { render :show, status: :created, location: @contribucion}
      end
    end
  end

  # PATCH/PUT /contribucions/1
  # PATCH/PUT /contribucions/1.json
  def update
    respond_to do |format|
      if @contribucion.update(contribucion_params)
        format.html { redirect_to @contribucion, notice: 'Contribucion was successfully updated.' }
        format.json { render :show, status: :ok, location: @contribucion }
      else
        format.html { render :edit }
        format.json { render json: @contribucion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contribucions/1
  # DELETE /contribucions/1.json
  def destroy
    @contribucion.destroy
    respond_to do |format|
      format.html { redirect_to contribucions_url, notice: 'Contribucion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  #PUT /contribucions/1/upVote
  def upvote
    @points = @contribucion.points + 1
    respond_to do |format|
      if @contribucion.update_attribute(:points, @points)  
        format.html { redirect_to contribucions_url}
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @contribucion.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribucion
        @contribucion = Contribucion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribucion_params
      params.require(:contribucion).permit(:user_id, :title, :url, :text)
    end
    
end
