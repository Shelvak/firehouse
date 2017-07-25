class FilesController < ApplicationController
  before_action :check_permissions

  def download
    path = params[:path].to_s
    file = (PRIVATE_PATH + path).expand_path

    if path.start_with? 'dockets'
      send_file_with_headers(
        file, non_existent_path: :back
      )
    end
  end

  private

  def send_file_with_headers(file, options = {})
    not_file_redirect_to = options[:non_existent_path]
    not_file_notice = (
      options[:non_existent_notice] || t('view.files.non_existent')
    )

    if file.exist? && file.file?
      mime_type = Mime::Type.lookup_by_extension(File.extname(file)[1..-1])

      response.headers['Last-Modified'] = File.mtime(file).httpdate
      response.headers['Cache-Control'] = 'private, no-store'
      response.headers['Content-Length'] = file.size.to_s

      send_file file, type: (mime_type || 'application/octet-stream')
    else
      redirect_to not_file_redirect_to, notice: not_file_notice
    end
  end

  def check_permissions

  end
end
