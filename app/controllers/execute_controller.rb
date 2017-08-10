class ExecuteController < ApplicationController
  def excute_command
    command = params[:command]
    response = JsonReturnObject.new
    output = ''

    if command
      Open3.popen2e(command) do |_stdin, stdout_stderr, wait_thread|
        Thread.new do
          stdout_stderr.each { |l| output << l }
        end

        wait_thread.value
      end
    end
    # p output
    response.message = output
    response.code = 200
    render json: response.to_json
  end
end
