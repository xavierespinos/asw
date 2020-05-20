class Api::ContribucionsController < Api::BaseController
  before_action :set_controllers

  #---------------------------------------------- Probado ----------------------------------------------#
  # GET /contribucions/api/contribucions
  # GET /contribucions.json
  def urls
    if params[:id].nil?
      resultListFind(@contribucionsController.getAllContribucioUrl)
    else
      show
    end
  end

  # GET /contribucions/api/contribucions
  # GET /contribucions.json
  def asks
    resultListFind(@contribucionsController.getAllContribucioAsk)
  end
  
  # GET /contribucions/api/contribucions
  # GET /contribucions.json
  def news
    resultListFind(@contribucionsController.getAllContribucio)
  end
  
  # GET /api/contribucions/1
  # GET /contribucions/1.json
  def show
    idContribucio = params[:id]
    result(@contribucionsController.getContribucioById(idContribucio))
  end

  def fromUser
    resultListFind(Contribucion.where(user_id:params[:id]))
  end

  # GET /api/contribucions/:id/comentaris
  # GET /comentaris.json
  def comentaris
      idContribucio = params[:id]
      @comments = @contribucionsController.getComentarisContribucio(idContribucio)
      resultListFind(@comments)
  end
  
  # POST /contribucions/api/contribucions/1
  # POST /contribucions/1.json
  def new
     if @usersController.isValidApiToken(getApiKey)
       if @contribucionsController.getContribucioByUrl(contribucion_params[:url]).nil?
         contribucio = Contribucion.new(contribucion_params)
         contribucio.user_id = @usersController.getUserByApiToken(getApiKey).id
         if @contribucionsController.addContribucio(contribucio)
           render json: contribucio, status: :ok
         else
           render json: {error: 'Contribucio not created'}, status: :bad_request
         end
       else
         contribucio = @contribucionsController.getContribucioByUrl(contribucion_params[:url])[0]
         render json: contribucio, status: :ok
       end
     else
       render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
     end
  end

  def destroy
    if @usersController.isValidApiToken(getApiKey)
      idContribucio = params[:id]
      idUser = @usersController.getUserByApiToken(getApiKey).id
      if @contribucionsController.deleteContribucio(idContribucio,idUser)
        render json: {ok: 'ok'} , status: :ok
      else
        render json: {error: 'Bad request'} , status: :bad_request
      end
    else
      render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
    end
  end
  
  
  def upvote
    if @usersController.isValidApiToken(getApiKey)
      if !params[:id].nil?
        u = @usersController.getUserByApiToken(getApiKey)
        if !@contribucionsController.addContribucionsVoted(u.id,params[:id]).nil?
          @contribucionsController.addUpVotedContribution(params[:id],true)
          c = Contribucion.find(params[:id])
          result(c)
        else
          render json: {error: "Contribution already voted"}, status: :bad_request
        end
      else
         render json: {error: "Need id contribution"}, status: :bad_request
      end
    else
      render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
    end
  end


  def downvote
    if @usersController.isValidApiToken(getApiKey)
      if !params[:id].nil?
        u = @usersController.getUserByApiToken(getApiKey)
        if @contribucionsController.deleteContribucionsVoted(u.id,params[:id])
          @contribucionsController.addUpVotedContribution(params[:id],false)
          c = Contribucion.find(params[:id])
          result(c)
        else
          render json: {error: "Contribution not voted"}, status: :not_found
        end
      else
        render json: {error: "Need id contribution"}, status: :bad_request
      end
    else
      render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
    end
  end

  def upvotedfromuser
    if !params[:id].nil?
      resultListFind(@contribucionsController.getContribucionsLiked(params[:id]))
    else
      render json: {error: "Need id user"}, status: :bad_request
    end
  end

  private

  def resultListFind(list)
    if list.count > 0
      render json: list, status: :ok
    else
      render json: {error: 'No content'}, status: :no_content
    end
  end

  def result(element)
    if element.nil?
      render json: {error: 'No content'}, status: :no_content
    else
      render json: element, status: :ok
    end
  end

  def set_controllers
    @contribucionsController = ContribucionsController.new
    @usersController = UsersController.new
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

  def contribucion_params
    params.require(:contribucion).permit(:user_id, :title, :url, :text)
  end

  #--------------------------------------------------------------------------------------------#
end