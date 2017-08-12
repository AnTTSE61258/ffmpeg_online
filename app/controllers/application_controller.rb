require 'open3'
class ApplicationController < ActionController::Base
  def current_request
    @request = Request.find(session[:request_id]) if session[:request_id]
    @request = Request.new unless @request
  end
  def set_current_request(request)
    session[:request_id] = request.id
  end
  def destroy_current_request
    session[:request_id] = nil
    current_request.destroy
  end
end
