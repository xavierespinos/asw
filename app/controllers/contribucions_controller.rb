class ContribucionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :newPage,:getAllContribucio,:getAllContribucioAsk,:getAllContribucioUrl,:addContribucio,:addComment,:getUser,:getContribucioById]
  before_action :set_contribucion, only: [:show, :edit, :update, :destroy, :upvote]

  # GET /contribucions
  # GET /contribucions.json
  def index
    @contribucions = getAllContribucioUrl
  end

  # GET /contribucions/askPage
  # GET /contribucions/askPage.json
  def askPage
    @contribucions = getAllContribucioAsk
    render :partial  => 'index', :locals => { :contribucions => @contribucions } 
  end

  # GET /contribucions/newPage
  # GET /contribucions/newPage.json
  def newPage
    @contribucions = getAllContribucio
    render :partial  => 'index', :locals => { :contribucions => @contribucions } 
  end

  def submitted
    #::Rails.logger.info "\n***\nVar: #{idUser}\n***\n"
    idUser = params[:id]
    user = getUser(idUser)
    @tipo = "#{user.email} submissions"
    @contribucions = getContribucionsUser(idUser)
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
      idUser = current_user().id
      idContribucion = params[:id]
      content = params[:content]
      @comment = addComment(idUser,idContribucion,content)
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
    if @param == "" or !Contribucion.exists?(url: @param) #si es un text o url nou el guarda
      @contribucion = Contribucion.new(contribucion_params)
      @contribucion.user_id = current_user().id
      respond_to do |format|
        if addContribucio(@contribucion)
          format.html { redirect_to @contribucion, notice: 'Contribucion was successfully created.' }
          format.json { render :show, status: :created, location: @contribucion }
        else
            format.html { render :new } ## Specify the format in which you are rendering "new" page
            format.json { render json: @reservation.errors } ## You might want to specify a json format as well
        end
      end
    else #si url existeix fa el show
      respond_to do |format|
        @contribucion = getContribucioByUrl(@param)
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
  
  def liked
    #::Rails.logger.info "\n***\nVar: #{idUser}\n***\n"
    idUser = params[:id]
    @contribucions = getContribucionsLiked(idUser)
    render :partial  => 'index', :locals => { :contribucions => @contribucions } 
  end
  
  #PUT /contribucions/1/upvote
  def upvote
      if params[:desvotar] == "0"
        updateVote = false
        if !addContribucionsVoted(current_user().id,@contribucion.id).nil?
          @contribucion.points += 1
          updateVote = true
        end
      else
        if deleteContribucionsVoted(current_user().id,@contribucion.id)
          @contribucion.points -= 1
          updateVote = true
        end
      end
      respond_to do |format|
        if updateVote
          @contribucion.update_attribute(:points, @contribucion.points)
        end
        if params[:lloc] == "main"
          format.html { redirect_to contribucions_url}
          format.json { head :no_content } 
        else 
          format.html { redirect_to @contribucion}
          format.json { head :no_content }
        end
      end
  end

  def addContribucionsVoted(idUser,idContribucio)
    if !ContribucionsVoted.exists?(user: idUser,contribucion: idContribucio)
      return ContribucionsVoted.create(user: idUser,contribucion: idContribucio)
    end
    return nil
  end

  def deleteContribucionsVoted(idUser,idContribucio)
    if ContribucionsVoted.exists?(user: idUser,contribucion: idContribucio)
      contribucionsVoted = ContribucionsVoted.where(user: idUser, contribucion: idContribucio).limit(1)
      return contribucionsVoted[0].destroy
    end
    return false
  end

  def addUpVotedContribution(idContribucion,add)
    c= Contribucion.find(idContribucion)
    if add
      c.points += 1
    else
      c.points -= 1
    end
    return c.update_attribute(:points, c.points)
  end

  def getAllContribucioUrl
    return Contribucion.where(tipo: "url").order("created_at DESC")
  end

  def getAllContribucioAsk
    return Contribucion..where(tipo: "ask").order("created_at DESC")
  end

  def getAllContribucio
    return Contribucion.all.order("created_at DESC")
  end

  def getAllContribucioUrlApi(idUser)
     result = Contribucion.all.joins(:user,"LEFT JOIN contribucions_voteds ON contribucions_voteds.contribucion = contribucions.id and contribucions_voteds.user = " + String(idUser)).select('contribucions.*','users.email','contribucions_voteds.user as user_id_voted').where(tipo: "url").order("created_at DESC")
     return result
  end

  def getAllContribucioAskApi(idUser)
     result = Contribucion.all.joins(:user,"LEFT JOIN contribucions_voteds ON contribucions_voteds.contribucion = contribucions.id and contribucions_voteds.user = " + String(idUser)).select('contribucions.*','users.email','contribucions_voteds.user as user_id_voted').where(tipo: "ask").order("created_at DESC")
     return result
  end

  def getAllContribucioApi(idUser)
    result =  Contribucion.all.joins(:user,"LEFT JOIN contribucions_voteds ON contribucions_voteds.contribucion = contribucions.id and contribucions_voteds.user = " + String(idUser)).select('contribucions.*','users.email','contribucions_voteds.user as user_id_voted').order("created_at DESC")
    return result
  end

  def getUser(idUser)
    return User.find(idUser)
  end

  def getContribucionsUser(idUser)
    return Contribucion.where(uid: idUser)
  end
  
  def getContribucionsLiked(idUser)
    @contribucions = []
    @contribucionsvoted = ContribucionsVoted.where("contribucions_voteds.user = ?", idUser)
    @contribucionsvoted.each do |c|
      @contribucions << Contribucion.joins(:user,"LEFT JOIN contribucions_voteds ON contribucions_voteds.contribucion = contribucions.id and contribucions_voteds.user = " + String(idUser)).select('contribucions.*','users.email','contribucions_voteds.user as user_id_voted').find(c.contribucion)
    end
    return @contribucions
  end

  def addComment(idUser,idContribucion,content)
    contribucion = getContribucioById(idContribucion,0)
    return contribucion.comentaris.create(text: content, user_id: idUser)
  end

  def deleteContribucio(idContribucio,idUser)
    c = Contribucion.where(id: idContribucio, user_id: idUser).limit(1)
    if c[0].nil?
      return false
    else
      return c[0].destroy
    end
  end

  def getContribucioByUrl(contUrl,idUser)
    c =Contribucion.joins(:user,"LEFT JOIN contribucions_voteds ON contribucions_voteds.contribucion = contribucions.id and contribucions_voteds.user = " + String(idUser)).select('contribucions.*','users.email','contribucions_voteds.user as user_id_voted').where(url: contUrl)
    if c.length > 0
      return c[0]
    else
      return nil
    end
  end

  def getContribucioByIdUser(idUser)
    return Contribucion.joins(:user,"LEFT JOIN contribucions_voteds ON contribucions_voteds.contribucion = contribucions.id and contribucions_voteds.user = " + String(idUser)).select('contribucions.*','users.email','contribucions_voteds.user as user_id_voted').where(user: idUser)
  end


  def getContribucioById(idContribucion,idUser)
    return  Contribucion.joins(:user,"LEFT JOIN contribucions_voteds ON contribucions_voteds.contribucion = contribucions.id and contribucions_voteds.user = " + String(idUser)).select('contribucions.*','users.email','contribucions_voteds.user as user_id_voted').find(idContribucion )

  end

  def addContribucio(contribucion)
    if contribucion.url.empty?
      contribucion.tipo = "ask"
    else
      contribucion.tipo = "url"
    end
    return contribucion.save
  end

  def getComentarisContribucio(idContribucio)
    return Comentari.where("contribucion_id = ?", idContribucio)
  end

  def getComentarisContribucioApi(idContribucio,idUser)
    return Comentari.joins(:user,:contribucion,"LEFT JOIN comentaris_voteds ON comentaris_voteds.comentari = comentaris.id and comentaris_voteds.uid = " + String(idUser)).select('comentaris.*','contribucions.title as contribucion_title','users.email','comentaris_voteds.uid as user_id_voted').where("contribucion_id = ?", idContribucio)
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

