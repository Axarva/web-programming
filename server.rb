#!/usr/bin/env ruby
require 'webrick'
require 'erb'
require 'webrick/httpservlet/erbhandler'
require 'webrick/httpservlet/cgihandler'

# Get the script's directory as the project root
root = __dir__
server = WEBrick::HTTPServer.new(
  Port: 8080,
  DocumentRoot: root
)

puts "Server running at http://localhost:8080"
puts "Serving files from: #{root}"
puts "---"
puts "MANUAL ROUTER LOADED:"
puts " - .rb files will be run as CGI."
puts " - .rhtml files will be run as ERB."
puts " - Directories will be listed."

# --- The One Proc to Rule Them All ---
server.mount_proc('/') do |req, res|
  
  # 1. GET THE FILE PATH
  path = File.join(root, req.path)

  # 2. SANITIZE THE PATH
  unless File.expand_path(path).start_with?(root)
    res.status = 403
    res.body = "Forbidden: Path traversal"
    next
  end

  # 3. ROUTE THE REQUEST
  
  # --- RULE A: If it's a .rb file, run as CGI ---
  if File.extname(path) == '.rb' && File.exist?(path)
    begin
      puts "ROUTE: Running as CGI: #{req.path}"
      
      # --- FIX 1 HERE ---
      # We now pass the *full filesystem path* (`path`) to the
      # handler, not the URL path (`req.path`).
      handler = WEBrick::HTTPServlet::CGIHandler.new(server, path)
      # ------------------
      
      handler.service(req, res)
    rescue => e
      res.status = 500
      res.body = "CGI SCRIPT ERROR:\n#{e.message}"
    end

  # --- RULE B: If it's a .rhtml file, run as ERB (with our fix) ---
  elsif File.extname(path) == '.rhtml' && File.exist?(path)
    begin
      puts "ROUTE: Running as ERB: #{req.path}"
      res['Content-Type'] = 'text/html'
      
      handler = WEBrick::HTTPServlet::ERBHandler.new(server, path)
      handler.service(req, res)
    rescue => e
      res.status = 500
      res['Content-Type'] = 'text/plain'
      res.body = "ERB SCRIPT ERROR:\n#{e.message}\n#{e.backtrace.join("\n")}"
    end

  # --- FIX 2 HERE: If it's a DIRECTORY, list it ---
  elsif File.directory?(path)
    puts "ROUTE: Listing directory: #{req.path}"
    res.status = 200
    res['Content-Type'] = 'text/html'
    
    # Create a link to go "Up"
    up_path = (req.path == '/') ? nil : File.dirname(req.path)
    
    res.body = "<html><head><title>Index of #{req.path}</title></head>"
    res.body << "<body><h1>Index of #{req.path}</h1><ul>"
    res.body << "<li><a href=\"#{up_path}\">.. (Up)</a></li>" if up_path

    # List files in the directory
    Dir.foreach(path).sort.each do |filename|
      next if filename == '.' || filename == '..' # Skip . and ..
      
      # Add a / to subdirectories
      display_name = filename
      full_file_path = File.join(path, filename)
      display_name << '/' if File.directory?(full_file_path)

      # Create the link
      # CGI.escape to handle spaces or special chars in filenames
      res.body << "<li><a href=\"#{File.join(req.path, filename)}\">#{display_name}</a></li>"
    end
    
    res.body << "</ul></body></html>"
  # --------------------------------------------

  # --- RULE D: If it's a *different* file (like .db), DENY IT ---
  elsif File.exist?(path)
    puts "ROUTE: Denying access to static file: #{req.path}"
    res.status = 403
    res.body = "Forbidden: Access to this file type is not allowed."
  
  # --- RULE E: Otherwise, 404 Not Found ---
  else
    puts "ROUTE: Not Found: #{req.path}"
    res.status = 404
    res.body = "Not Found: #{req.path}"
  end
end

# A final note: The "favicon.ico" 404 error is totally normal.
# It's your browser asking for a bookmark icon. You can ignore it.

trap("INT") { server.shutdown }
server.start
