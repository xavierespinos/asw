class ComentarisController < ApplicationController
  before_action :authenticate_user!
  
  def new
    comentari_id = 0
    @id_reply = params[:id_comentari]
    @id_contrib = params[:id_contribucio]
    if params[:comentari_id] != nil then
      comentari_id = params[:comentari_id] 
    end
    initNew(params[:contribucion_id],comentari_id)
  end

  def create
    @comentari = Comentari.new(comentari_params)
    @comentari.user_id = current_user.id
    respond_to do |format|
      if @comentari.save
        initNew(@comentari.contribucion_id,@comentari.comentari_id)
        format.html { redirect_to "/contribucions/#{@comentari.contribucion_id}", notice: 'reply was successfully created.' }
        format.json { render :show, status: :created, location: @contribucion }
      else
        url = "/contribucions/#{@comentari.contribucion_id}"
        if @comentari.comentari_id != 0 then
          url += "/comentaris/#{@comentari.comentari_id}"  
        end
          format.html { redirect_to url } ## Specify the format in which you are rendering "new" page
          format.json { render json: @reservation.errors } ## You might want to specify a json format as well
      end
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end
  
  def threads
    idUser = params[:user_id]
    user = User.find(idUser)
    @tipo = "#{user.email} threads"
    @comentari = Comentari.new
    @comentaris = getThreads(idUser)
  end

  def liked
    #::Rails.logger.info "\n***\nVar: #{idUser}\n***\n"
    idUser = params[:id]
    @comentaris = getComentarisLiked(idUser)
    render :partial  => 'comentarisvoted', :locals => { :comentaris => @comentaris }
  end

  def show
    @comentari = Comentari.find(params[:id])
    @comentari2 = Comentari.new()
    @comentari2.user_id = current_user.id
    @comentari2.contribucion_id = @comentari.contribucion_id
    @comentari2.comentari_id = @comentari.id
  end

  def index
  end
  
  #PUT /comentaris/1/upVote
  def upvote
    if !params[:id].nil?
      @comentari = Comentari.find(params[:id])
      if params[:desvote] == "0"
        updateVote = false
        if !addComentarisVoted(current_user().id,@comentari.id).nil? 
          @points = @comentari.points + 1
          updateVote = true
        end
      else
        if deleteComentarisVoted(current_user().id,@comentari.id)
          @points = @comentari.points - 1
          updateVote = true
        end
      end
      if !current_user().nil?
        respond_to do |format|
          if updateVote
            addUpVotedComentaris(@comentari)
          end
          @comentari.update_attribute(:points, @points) 
          if params[:lloc] == "main"
            format.html { redirect_to contribucions_url}
            format.json { head :no_content } 
          else 
            format.html { redirect_to @comentari}
            format.json { head :no_content }
          end
        end
      else
        redirect_to '/login'
      end
    end
  end
  
  def comentari_params
    params.require(:comentari).permit(:text, :contribucion_id, :comentari_id)
  end

  def initNew(contribucion_id,comentari_id)
    @contribucion = Contribucion.find(contribucion_id)
    @comentari = Comentari.new(comentari_params)
    if comentari_id == 0 then
      @comentaris = Comentari.where(contribucion_id: contribucion_id)
    else
      @comentaris = Comentari.where(id: comentari_id )
    end
    @comentari.contribucion_id = contribucion_id  
    @comentari.comentari_id = comentari_id 
  end

  def getThreads(idUser)
    comentaris = []
    comentaris += Comentari.where(user_id: idUser,comentari_id: 0)
    return comentaris
  end
  
  def getComentarisLiked(idUser)
    @comentaris = []
    @comentarisvoted = ComentarisVoted.where("user = ?", idUser)
    @comentarisvoted.each do |c|
      @comentaris << Comentari.find(c.comentari)
    end
    return @comentaris
  end
  
  def deleteComentariVoted(idUser,idComentari)
    if ComentarisVoted.exists?(user: idUser,comentari: idComentari)
      comentarisVoted = ComentarisVoted.where(user: current_user().id, comentari: @comentari.id).limit(1)
      return comentarisVoted[0].destroy
    end
    return false
  end
  
  def addUpVotedComentaris(comentari)
    return cocomentari.update_attribute(:points, comentari.points)
  end 
  
  def addComentarisVoted(idUser,idComentari)
    if !ComentarisVoted.exists?(user: idUser,comentari: idComentari)
      return  ComentarisVoted.create(user: idUser, comentari: idComentari)
    end
    return nil
  end

  def deleteComentariVoted(idUser,idComentari)
    if ComentarisVoted.exists?(user: idUser,contribucion: idContribucio)
      comentarisVoted = ComentarisVoted.where(user: current_user().id, comentari: @comentari.id).limit(1)
      return comentarisVoted[0].destroy
    end
    return false
  end
  
end

