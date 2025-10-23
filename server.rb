#!/usr/bin/env ruby
require 'webrick'

# Setup server
server = WEBrick::HTTPServer.new(
  Port: 8080,
  DocumentRoot: Dir.pwd
)

# Enable CGI execution for /cgi-bin
server.mount('/cgi-bin', WEBrick::HTTPServlet::FileHandler, 'cgi-bin', {
  FancyIndexing: true,
  HandlerTable: {
    'rb' => WEBrick::HTTPServlet::CGIHandler
  }
})

# Graceful shutdown
trap("INT") { server.shutdown }

puts "Server running at http://localhost:8080"
server.start
