# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  def create
    crearUserSiNoExiste
    super
  end

  def user_params
      params.require(:user).permit(:email, :password)
  end
  
  def crearUserSiNoExiste

    if user_params != nil  then
      user = User.new(user_params)
      user2 = User.where(email: user.email).take  
      if user2 == nil then
        user.save
      end
    end
  end
  
end