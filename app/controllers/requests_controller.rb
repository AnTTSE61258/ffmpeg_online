class RequestsController < ApplicationController
  def create
    return render html: 'Error' unless params[:request]
    @request = Request.new(request_params)
    @request.format = Format.first.name
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
    request = current_request
    key = params[:key]
    value = params[:value]
    case key
      when 'format' then
        request.format = value
    end
    request.save
    render json: current_request.to_json
  end

  def process_request
    request = current_request
    unless request && request.file_url
      render_json("[ERROR] Please upload your file", 400)
      return
    end
    movie = FFMPEG::Movie.new(Dir.pwd + '/public' + request.file_url)
    FileUtils.mkdir_p(Dir.pwd + '/public/output') unless File.exist?(Dir.pwd + '/public/output/')
    output_url = Dir.pwd + '/public/output/' + request.id.to_s + ".#{request.format}"
    debugger
    begin
      movie.transcode(output_url) {|progress| FirebaseHelper::push_log(request.id.to_s, "Processing: " + (progress*100).to_s + ' %')}
      FirebaseHelper::push_log(request.id.to_s, "Processed successfully!!!")
    rescue StandardError => e
      FirebaseHelper::push_log(request.id.to_s, e.message)
    end
    render json: ('/output/' + request.id.to_s + ".#{request.format}").to_json
  end

  def clear_log
    request = current_request
    unless request && request.file_url
      render_json("[ERROR] Please upload your file", 400)
      return
    end
    FirebaseHelper::clear_log request.id
  end

  private

  def request_params
    params.require(:request).permit(:file)
  end

  def render_json(message, status)

      render json: message.gsub("\n", "<br />"),status: status
  end
end
