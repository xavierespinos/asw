class Api::Contribucions < Api::BaseController
  
  # GET /contribucions/api/contribucions
  # GET /contribucions.json
  def all
    @contribucions = Contribucion.find.all()
    render json: @contribucions
  end
  
  # GET /contribucions/api/contribucions
  # GET /contribucions.json
  def asks
    @contribucions = Contribucion.all.select{|c| c.text != ""}
    render json: @contribucions 
  end
  
  # GET /contribucions/api/contribucions
  # GET /contribucions.json
  def news
    @contribucions = Contribucion.all.select{|c| c.url != ""} 
    render json: @contribucions
  end
  
  # GET /contribucions/api/contribucions/1
  # GET /contribucions/1.json
  def show
    render json: @contribucion
  end
  
  # GET /contribucions/api/contribucions/1
  # GET /comentaris.json
  def comentaris 
      @comments = @contribucion.comentaris
      render json: @comments
  end
  
  # POST /contribucions/api/contribucions/1
  # POST /contribucions/1.json
  def new
    if !params[:apiKey].nil?
     @contribucion = Contribucion.new
     @contribucion.user_id = current_user.id
      render json: @contribucion
    else 
      format.json { render status: :method_not_allowed }
    end
  end
  
  def upvote
    if !params[:apiKey].nil?
      @points = @contribucion.points + 1
      @contribucion = Contribucion.find(params[:id])
      @contribucion.update_attribute(:points, @points) 
      respond_to do |format|
        format.json{ render json: @contribucion, status: 200 }
      end
    else 
      respond_to do |format|
        format.json { render status: :method_not_allowed }
      end
    end
  end
  
  def create
    if !params[:apiKey].nil?
      @param = contribucion_params[:url]
      if @param == "" or (@param != "" and !Contribucion.exists?(url: @param)) #si es un text o url nou el guarda
        @contribucion = Contribucion.new(contribucion_params)
        if @contribucion.url.empty?
          @contribucion.tipo = "ask"
        else
          @contribucion.tipo = "url"
        end
        respond_to do |format|
          @contribucion.user_id= User.find_by_apiKey(params[:apiKey]).id
          if @contribucion.save
            format.json { render :show, status: :created, json: @submission }
          else
            format.json { render json: @submission.errors, status: :unprocessable_entity }
          end
        end
      else if @param != "" and Contribucion.exists?(url: @param) #si url existeix fa el show
        respond_to do |format|
          @contribucion = Contribucion.all.select{|c| c.url == @param}  
          format.json { render :show, json: @submission }
        end
      end
      end
    else
      format.json { render json: {errors: 'Method not Allowed'}, status: :method_not_allowed }
    end
  end
  
  def destroy
    if !params[:apiKey].nil?
      @user = User.find_by_apiKey(params[:apiKey])
      if(@user.posts.include?(Contribucion.find([:id])))
        @contribucion.destroy
      else
        respond_to do |format|
          format.json { render status: :method_not_allowed }
        end
      end
    end
  end
  
  def fromuser
    @contribucions = Contribucion.where(user_id:params[:id])
    if @submissions.count > 0
      respond_to do |format|
        format.json { render json: @contribucions.to_json(), status: 200}
      end
    else
      respond_to do |format|
        format.json { render json: {errors: 'No content'}, status: :no_content}
      end
    end
  end
  
end