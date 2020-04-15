class ComentarisController < ApplicationController
  before_action :authenticate_user!
  
  def new
    comentari_id = 0
    if params[:comentari_id] != nil then
      comentari_id = params[:comentari_id] 
    end
    initNew(params[:id],comentari_id,0)
  end

  def create
    ::Rails.logger.info "\n***\nVar: #{comentari_params}\n***\n"
    @comentari = Comentari.new(comentari_params)
    @comentari.user_id = current_user.id
    @comentari.save
    if @comentari.save
      initNew(@comentari.contribucion_id,@comentari.comentari_id,1)
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def show
    @comentari = Comentari.find(params[:id])
  end

  def index
  end
  
  def comentari_params
    params.require(:comentari).permit(:text, :contribucion_id, :comentari_id)
  end

  def initNew(contribucion_id,comentari_id,vRender)
    #::Rails.logger.info "\n***\nID:-------: #{comentari_id}\n***\n"
    @contribucion = Contribucion.find(contribucion_id)
    @comentari = Comentari.new
    if comentari_id == 0 then
      @comentaris = Comentari.where(contribucion_id: contribucion_id)
    else
      @comentaris = Comentari.where(id: comentari_id )
    end
    @comentari.contribucion_id = contribucion_id  
    @comentari.comentari_id = comentari_id 
    if vRender == 1 then
       render :new, :locals => {:contribucion => @contribucion, :comentari => @comentari, :comentaris => @comentaris}
    end
  end
  
end
