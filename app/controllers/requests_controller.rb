class RequestsController < ApplicationController
  GENERATING_THUMBNAILS_KEY = '[END] Generating_thumbnails...'
  def create
    unless params[:request]
      redirect_to root_path
      return
    end
    @request = Request.new(request_params)
    @request.format = Format.first.name
    movie = FFMPEG::Movie.new(Dir.pwd + '/public' + @request.file_url)
    @request.o_h = movie.height
    @request.o_w = movie.width
    @request.n_h = movie.height
    @request.n_w = movie.width
    if @request.save
      set_current_request @request
    else
      return render html 'Error'
    end
    Thread.new do
      # Generate thumbnails
      FirebaseHelper.push_log(@request.id.to_s, "[START] Generating_thumbnails...")
      movie = FFMPEG::Movie.new(Dir.pwd + '/public' + @request.file_url)
      movie.screenshot(Dir.pwd + format('/public/uploads/request/file/%s/', @request.id) + '/thumbnail_%d.jpg',
                       { vframes: 20, frame_rate: format('20/%s', movie.duration) },
                       validate: false, resolution: '320x240', quality: 31)
      FirebaseHelper.push_log(@request.id.to_s, GENERATING_THUMBNAILS_KEY)
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
    when 'size' then
      size = JSON.parse(value)
      request.n_h = size['height']
      request.n_w = size['width']
    end
    request.save
    FirebaseHelper.push_log(request.id.to_s, format('Set %s successfully. current value = %s', key, value))
    render json: current_request.to_json
  rescue => e
    FirebaseHelper.push_log(request.id.to_s, format('Cant set options due to exception: %s', e.message))
  end

  def process_request
    request = current_request
    unless request && request.file_url
      render_json('[ERROR] Please upload input file', 400)
      return
    end
    if request.format.empty?
      FirebaseHelper.push_log(request.id.to_s, '[ERROR] Please select output format')
      return
    end
    movie = FFMPEG::Movie.new(Dir.pwd + '/public' + request.file_url)
    FileUtils.mkdir_p(Dir.pwd + '/public/output') unless File.exist?(Dir.pwd + '/public/output/')
    output_url = Dir.pwd + '/public/output/' + request.id.to_s + ".#{request.format}"
    begin
      options = get_options request
      movie.transcode(output_url, options) { |progress| FirebaseHelper.push_log(request.id.to_s, 'Processing: ' + (progress * 100).to_s + ' %') }
      FirebaseHelper.push_log(request.id.to_s, 'Processed successfully!!!')
    rescue StandardError => e
      FirebaseHelper.push_log(request.id.to_s, e.message)
    end
    render json: ('/output/' + request.id.to_s + ".#{request.format}").to_json
  end

  def clear_log
    request = current_request
    unless request && request.file_url
      render_json('[ERROR] Please upload your file', 400)
      return
    end
    FirebaseHelper.clear_log request.id
  end

  def get_input_thumbnail
    request = current_request
    unless request && request.file_url
      render_json('[ERROR] Please upload input file', 400)
      return
    end
    render json: Dir.entries(Dir.pwd + format('/public/uploads/request/file/%s/', request.id)).map { |i| i.include?('.jpg') ? format('/uploads/request/file/%s/%s', request.id, i) : nil }.compact
  end

  private

  def request_params
    params.require(:request).permit(:file)
  end

  def render_json(message, status)
    render json: message.gsub("\n", '<br />'), status: status
  end

  def get_options(request)
    options = {}
    resolution = { 'resolution' => request.n_w.to_s + 'x' + request.n_h.to_s }
    options = options.merge(resolution)

    options
  end
end
