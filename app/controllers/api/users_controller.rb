class Api::UsersController < Api::BaseController
  before_action :set_controllers
  before_action :set_user
  
  # GET /users/1
  # GET /users/1.json
  def show
    idUser = params[:id]
    result(@usersController.getUserById(idUser))
  end
  
  # PATCH/PUT /users
  # PATCH/PUT /users/1.json
  def update
    if @usersController.isValidApiToken(getApiKey)
      user = @userController.getUserByApiToken(getApiKey())
      userparam = User.new(user_params_edit)
      
      ##validar por contrasenya
      if user.password == userparam.password
        if user.update(user_params_edit)
           render json: user , status: :ok
        else
           render json: @user.errors, status: :unprocessable_entity 
        end
      else
          render json: {error: 'wrong password'}, status: :unauthorized
      end
    else
         render json: {error: 'invalid apiKey or undefined'}, status: :unauthorized
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
      params.require(:user).permit(:name, :password, :description)
    end
    
    def set_controllers
      @usersController = UsersController.new
    end
    
    def set_user
      @user = User.find(params[:id])
    end
  
end