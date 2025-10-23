#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
cgi = CGI.new
name = cgi["family"] + " " + cgi["given"]
print cgi.header("text/html; charset=utf-8")
print <<EOF
<html><body>
<p>入力された氏名は #{name} です。</p>
</body></html>
EOF
