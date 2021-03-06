module MatzBot::Commands
  
  require 'open-uri'
  require 'rexml/document'

  if ENV['RUBUILDIUS_DIR'].nil?
    rubuildius_dir = `pwd`
  else
    rubuildius_dir = ENV['RUBUILDIUS_DIR']
  end

  GIT_URL = 'http://git.rubini.us/?p=code;a=atom'

  hup_proc = lambda {
	  trap("HUP", "IGNORE")
	  trap("HUP", hup_proc)
  }
  trap("HUP", hup_proc)

  abrt_proc = lambda {
	  trap("ABRT", "IGNORE")
	  trap("ABRT", abrt_proc)
  }
  trap("ABRT", abrt_proc)
  
  def update_git
    data = open(GIT_URL).read
   
    doc = REXML::Document.new(data)
   
    last_hash = session[:git_last_hash]
    person = nil
    top_hash = nil
    
    REXML::XPath.each(doc, "//entry") do |entry|
      title = REXML::XPath.first(entry, "./title")
      link =  REXML::XPath.first(entry, "./link")
      name =  REXML::XPath.first(entry, "./author/name")
      hash = link.attributes['href'].split("=").last
      
      top_hash = hash if top_hash.nil?
      
      break if hash == last_hash

      # we need to put the hast already in now, otherwise it might run the build twice.
      session[:git_last_hash] = top_hash

      person = name.text
      build  = IO.popen("~/rubuildius/bin/rubinius.sh #{hash}", "r+") { |p| p.read }
      unless build.empty?
	say "#{person}: #{hash[0..8]}; #{build}"
        #build.split("\n").map{|x| say "  * " << x}
      end

      build =~ /(\d*) failure/
      num_failures = $1.to_i

      build =~ /(\d*) error/
      num_errors = $1.to_i

      email_to = 'rubinius-dev@googlegroups.com'

      if num_failures > 0 || num_errors > 0 || build =~ /failed/
        IO.popen("/usr/sbin/sendmail -f rubuildius@spcom.org #{email_to}", "r+") do |p|
	  p.write("To: #{email_to}\r\n")
	  p.write("Subject: Rubuildius CI error/failure\r\n")
          p.write("\r\n#{person}: #{hash[0..8]}; #{build}\r\n")
        end
      end

      break # only run it for the very last commit
    end
  end
  
  Signal.trap("USR2") do
    update_git
  end
end
