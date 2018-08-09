class CallCenterController < ApplicationController
  def index
    sample_list = [
      { "id":1, "timestamp":"2018-07-27T11:44:06Z", "origen":"37", "destino":"01141245550", "atendio":"SIP/linea1-00000003", "duracion":353, "estado":"ANSWERED", "uniqueid":"asterisk.bvgc.org-1532702646.2"}
    ]

    list = open(ENV['CALL_CENTER_ENDPOINT']).read rescue nil

    list = list ? JSON.parse(list) : sample_list

    @list = list.map do |l|
      OpenStruct.new(l)
    end
  end

  def download
    file =  Rails.root.join('llamadas', params[:id] + '.wav')

    if File.exists?(file)
      o_file = File.open(file)

      response.headers['Last-Modified'] = File.mtime(o_file).httpdate
      response.headers['Content-Length'] = o_file.size.to_s
      response.headers['x-content-duration'] = '354' # o_file.size.to_s

      send_file file, type: 'audio/wav', disposition: 'inline'
    else
      head 404
    end
  end
end
