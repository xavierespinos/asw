class Api::Users < Api::BaseController
  before_action :set_controllers
  before_action :set_user
  
  # GET /users/1
  # GET /users/1.json
  def show
    idUser = params[:id]
    result(@usersController.getUserById(idUser))
  end
  
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params_edit)
      format.json { render status: :ok, json: @user }
    else
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
  
  
  
  def result(element)
    if element.nil?
      render json: {error: 'No content'}, status: :no_content
    else
      render json: element, status: :ok
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

  private
  
    def user_params_edit
      params.permit(:name, :email, :password, :password_confirmation, :about)
    end
    
    def set_controllers
      @usersController = UsersController.new
    end
    
    def set_user
      @user = User.find(params[:id])
    end
  
end