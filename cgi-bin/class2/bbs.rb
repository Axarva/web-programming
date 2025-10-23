#!/home/satellanutella/.rbenv/shims/ruby
# encoding: utf-8
#!/usr/bin/env ruby
# Student ID: 202513228
# Student name: Atharva Timsna
# Class: Web Programming
# Professor: 永森 光晴 
# Submission for second assignment

require 'cgi'
cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
begin
  data = open("bbsdata.txt", "r:UTF-8")
  messages = CGI.escapeHTML(data.read)
  data.close
rescue => ex
  print <<EOS
    <html><body><pre>
    #{ex.message}
    #{CGI.escapeHTML(ex.backtrace.join("\n"))}
    </pre></body></html>
EOS
end

print <<EOF
<html>
<head><meta charset="utf-8"><title>Simple BBS</title></head>
<body>
  <h1>１行掲示板 </h1>
  <p>メッセージをどうぞ。</p>

  <form action="update.rb" method="post">
      <span>メッセージ: </span><textarea name="message" rows="1" cols="60" placeholder="Write a message" required="required"></textarea>
      <br>
      <span>お名前: </span><input type="text" name="name" placeholder="Name" required="required">
      <br>
      <input type="submit" value="書き込む">
      <input type="reset" value="クリア">
  </form>
  <hr>
  <pre>
#{messages}
  </pre>
</body>
</html>
EOF
