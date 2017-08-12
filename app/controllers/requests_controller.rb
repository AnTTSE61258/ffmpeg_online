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

  private

  def request_params
    params.require(:request).permit(:file)
  end
end
