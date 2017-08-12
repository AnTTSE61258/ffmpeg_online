class RequestsController < ApplicationController
  def create
    return render html: 'Error' unless params[:request]
    @request = Request.new(request_params)
    if @request.save
      set_current_request @request
    else
      return render html 'Error'
    end

    redirect_to root_path
  end

  def destroy
    destroy_current_request
    redirect_to root_path
  end

  def set_option
    request = current_request;
    key = params[:key]
    value = params[:value]
    case key
      when 'format' then
        request.format = value

    end
    request.save
    render :json => current_request.to_json
  end

  private
  def request_params
    params.require(:request).permit(:file)
  end
end
