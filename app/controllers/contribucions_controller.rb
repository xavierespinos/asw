class ContribucionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :newPage]
  before_action :set_contribucion, only: [:show, :edit, :update, :destroy, :upvote]

  # GET /contribucions
  # GET /contribucions.json
  def index
    @contribucions = Contribucion.all.select{|c| c.url != ""}  
  end
  
  
  # GET /contribucions/askPage
  # GET /contribucions/askPage.json
  def askPage
    @contribucions = Contribucion.all.select{|c| c.text != ""}
    render :partial  => 'index', :locals => { :contribucions => @contribucions } 
  end
  
  # GET /contribucions/newPage
  # GET /contribucions/newPage.json
  def newPage
    @contribucions = Contribucion.all.order("created_at DESC")
    render :partial  => 'index', :locals => { :contribucions => @contribucions } 
  end
  
  def submitted
    #::Rails.logger.info "\n***\nVar: #{idUser}\n***\n"
    idUser = params[:id]
    user = User.find(idUser)
    @tipo = "#{user.email} submissions"
    @contribucions = Contribucion.where("user_id = ?", idUser)
    render :partial  => 'index', :locals => { :contribucions => @contribucions } 
  end

  # GET /contribucions/1
  # GET /contribucions/1.json
  def show
    @comentaris = @contribucion.comentaris
  end

  # GET /contribucions/new
  def new
    @contribucion = Contribucion.new
    @contribucion.user_id = current_user.id
  end

  # GET /contribucions/1/edit
  def edit
  end
  
  def comment
    if !current_user().nil?
      @user_id = current_user().id
      @contribucion = Contribucion.find(params[:id])
      @comment = @contribucion.comentaris.create(text: params[:content], user_id: @user_id)
      flash[:notice] = "Added your comment"
      redirect_to :action => "show", :id => params[:id]
    else
      redirect_to '/login'
    end
  end
  
  # POST /contribucions
  # POST /contribucions.json
  def create
    @param = contribucion_params[:url]
    if @param == "" or (@param != "" and !Contribucion.exists?(url: @param)) #si es un text o url nou el guarda
      @contribucion = Contribucion.new(contribucion_params)
      if @contribucion.url.empty?
        @contribucion.tipo = "ask"
      else
        @contribucion.tipo = "url"
      end
      respond_to do |format|
        @contribucion.user_id= current_user().id
        if @contribucion.save
          format.html { redirect_to @contribucion, notice: 'Contribucion was successfully created.' }
          format.json { render :show, status: :created, location: @contribucion }
        else
            format.html { render :new } ## Specify the format in which you are rendering "new" page
            format.json { render json: @reservation.errors } ## You might want to specify a json format as well
        end
      end
    else if @param != "" and Contribucion.exists?(url: @param) #si url existeix fa el show
      respond_to do |format|
        @contribucion = Contribucion.all.select{|c| c.url == @param}  
        format.html { redirect_to @contribucion}
        format.json { render :show, status: :created, location: @contribucion}
      end
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
    
    if !current_user().nil?
      respond_to do |format|
        @contribucion.update_attribute(:points, @points) 
        if params[:lloc] == "main"
          format.html { redirect_to contribucions_url}
          format.json { head :no_content } 
        else 
          format.html { redirect_to @contribucion}
          format.json { head :no_content }
        end
      end
    else
      redirect_to '/login'
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
