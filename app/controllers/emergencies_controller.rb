class EmergenciesController < ApplicationController
  def new
    page_not_found
  end

  def create
    emergency = Emergency.new(permit_emergency_params_for_create)
    if emergency.save
      render :json => {:emergency => emergency}.to_json, :status=>201
    else
      render :json => {:message => emergency.errors}.to_json, :status=>422
    end

  end

  def edit
    page_not_found
  end

  def update
    emergency = get_emergency
    if emergency.update(permit_emergency_params_for_update)
      render :json => {:emergency => emergency}.to_json, :status=>201
    else
      render :json => {:message => emergency.errors}.to_json, :status=>422
    end
  end

  def index
    emergencies = Emergency.all.as_json(:only=>[:code, :fire_severity, :police_severity, :medical_severity])
    render :json=>{:emergencies=> emergencies,:full_responses=> Emergency.full_responses}, :status=>200
  end

  def show
    emergency = get_emergency
    emergency.present? ? (render :json => {:emergency => emergency}.to_json) : (render :status => 404 )
  end

  def destroy
    page_not_found
  end

  private

  def get_emergency
    Emergency.find_by_code(params[:code])
  end

  def permit_emergency_params_for_create
    params.require(:emergency).permit(:code,:fire_severity, :police_severity, :medical_severity)
  end

  def permit_emergency_params_for_update
    params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
  end

end
