class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActionController::UnpermittedParameters do |e|
    render :status => 422, :json => {:message => e.message}
  end 

  def page_not_found
  	render :json => {:message => "page not found"}.to_json, :status => 404
  end
end
