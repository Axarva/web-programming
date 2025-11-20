#!/home/satellanutella/.rbenv/shims/ruby
#!/usr/bin/env ruby
# encoding: utf-8
# Student ID: 202513228
# Student name: Atharva Timsna
# Class: Web Programming
# Professor: 永森 光晴 
# Submission for second assignment

require 'cgi'
cgi = CGI.new

name = cgi["name"]
message = cgi["message"]
data = open("bbsdata.txt", "a:UTF-8")
data.write(name + " : " + message + "\n")
data.close
print cgi.header("text/html; charset=utf-8")
print <<EOF
<html><body>
<p>書き込みありがとうございます。</p>
<br>
<a href="bbs_js.rb">１行提示板に戻る</a>
</body></html>
EOF
