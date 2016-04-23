class RespondersController < ApplicationController
  def new
    page_not_found
  end

  def create
    responder = Responder.new(permit_responder_params_for_create)
    if responder.save
      render :json => {:responder => responder.to_json}, :status=>201
    else
      render :json => {:message => responder.errors}.to_json, :status=>422
    end
  end

  def edit
    page_not_found
  end

  def update
    responder = get_responder
    if responder.update(permit_responder_params_for_update)
      render :json => {:responder => responder}.to_json, :status=>201
    else
      render :json => {:message => responder.errors}.to_json, :status=>422
    end
  end

  def index
    byebug
    responders = Responder.all.as_json(:only=>[:emergency_code,:name,:type, :capacity, :on_duty])
    render :json => {:responders=> responders}, :status =>200
  end

  def show
    responder = get_responder
    responder.present? ? (render :json => {:responder => responder.to_json}) : (render :status => 404 )
  end

  def destroy
    page_not_found
  end

  private

  def get_responder
    Responder.find_by_name(params[:name])
  end

  def permit_responder_params_for_create
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def permit_responder_params_for_update
    params.require(:responder).permit(:on_duty)
  end
end

