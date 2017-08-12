require 'open3'
class ApplicationController < ActionController::Base
  def current_request
    return @request = Request.find(session[:request_id]) if session[:request_id]
    @request = Request.new unless @request
  end

  def set_current_request(request)
    session[:request_id] = request.id
  end

  def destroy_current_request
    request = current_request
    FileUtils.rm_rf('public/uploads/request/file/' + request.id.to_s)
    request.destroy
    session[:request_id] = nil
  end
end
