require 'net/ftp'

module Services
  class FtpClient
    def initialize(server)
      @ftp = Net::FTP.new(server)
    end

    def login(user, password)
      @ftp.login(user, password)
    end

    def get_text_file(remote_file, local_file = nil)
      @ftp.gettextfile(remote_file, local_file)
    end

    def close
      @ftp.close
    end
  end
end
