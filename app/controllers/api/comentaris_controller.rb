class Api::ComentarisController < Api::BaseController
  before_action :set_controllers


  def new
    if @usersController.isValidApiToken(getApiKey)
      if !params[:id].nil?
        comentari = Comentari.new(comentari_params)
        comentari.contribucion_id = params[:id]
        if Contribucion.exists?( comentari.contribucion_id)
          comentari.user_id = @usersController.getUserByApiToken(getApiKey).id
          if comentari.save
            render json: comentari, status: :ok
          else
            render json: comentari, status: :bad_request
          end
        else
          render json: {error: 'not exist contribution to add reply'}, status: :bad_request
        end
      else
        render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
      end
    else
      render json: {error: 'id contribution is required'}, status: :bad_request
    end
  end


  def show
    idComentari = params[:id]
    if !idComentari.nil?
      comentari = Comentari.find(idComentari)
      result(comentari)
    end
  end

  def showReplies
    idComentari = params[:id]
    if !idComentari.nil?
      comentaris = Comentari.where(comentari_id: idComentari)
      comentaris += getReplies(comentaris)
      result(comentaris)
    end
  end


  def getReplies(comentaris)
    comentaris2 = []
    comentaris.each do |c|
      comentaris2 += Comentari.where(comentari_id: c.id)
    end

    if comentaris2.count > 0
      comentaris2 += getReplies(comentaris2)
    end

    return comentaris2
  end


  def replies
    if @usersController.isValidApiToken(getApiKey)
      if !params[:id].nil?
          comentari = Comentari.new(comentari_params)
          comentari.comentari_id = params[:id]
          comentariBD = Comentari.find(comentari.comentari_id)
          if !comentariBD.nil?
            comentari.user_id = @usersController.getUserByApiToken(getApiKey).id
            comentari.contribucion_id = comentariBD.contribucion_id
            if comentari.save
              render json: comentari, status: :ok
            else
              render json: comentari, status: :bad_request
            end
          else
            render json: {error: 'not exist comment to add reply'}, status: :bad_request
          end
      else
        render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
      end
    else
      render json: {error: 'id comment is required'}, status: :bad_request
    end
  end


  def fromuser
    if !params[:id].nil?
      idUser = params[:id]
      comentaris = @comentarisController.getThreads(idUser)
      result(comentaris)
    else
      render json: "id user required", status: :bad_request
    end
  end


  def upvote
    if @usersController.isValidApiToken(getApiKey)
      if !params[:id].nil?
        u = @usersController.getUserByApiToken(getApiKey)
        if !@comentarisController.addComentarisVoted(u.id,params[:id]).nil?
          @comentarisController.addUpVotedComentari(params[:id],true)
          c = Comentari.find(params[:id])
          result(c)
        else
          render json: {error: "Comment already voted"}, status: :bad_request
        end
      else
        render json: {error: "Need id comment"}, status: :bad_request
      end
    else
      render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
    end
  end


  def downvote
    if @usersController.isValidApiToken(getApiKey)
      if !params[:id].nil?
        u = @usersController.getUserByApiToken(getApiKey)
        if @comentarisController.deleteComentarisVoted(u.id,params[:id])
          @comentarisController.addUpVotedComentari(params[:id],false)
          c = Comentari.find(params[:id])
          result(c)
        else
          render json: {error: "Comment not voted"}, status: :not_found
        end
      else
        render json: {error: "Need id comment"}, status: :bad_request
      end
    else
      render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
    end
  end

  def upvotedfromuser
    if !params[:id].nil?
      resultListFind(@comentarisController.getComentarisLiked(params[:id]))
    else
      render json: {error: "Need id user"}, status: :bad_request
    end
  end


  def comentari_params
    params.require(:comentari).permit(:text, :contribucion_id, :comentari_id)
  end


  def set_controllers
    @comentarisController = ComentarisController.new
    @usersController = UsersController.new
  end


  def result(element)
    if element.nil?
      render json: {error: 'No content'}, status: :no_content
    else
      render json: element, status: :ok
    end
  end


  def resultListFind(list)
    if list.count > 0
      render json: list, status: :ok
    else
      render json: {error: 'No content'}, status: :no_content
    end
  end


  def getApiKey()
    result = ""
    begin
      if request.headers["apiKey"] != ""
        result =  request.headers["apiKey"]
      end
    rescue
    end
    return result
  end

end