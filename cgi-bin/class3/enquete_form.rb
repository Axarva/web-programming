#!/home/satellanutella/.rbenv/shims/ruby
# encoding: utf-8
#!/usr/bin/env ruby
# Student ID: 202513228
# Student name: Atharva Timsina
# Class: Web Programming
# Professor: 永森 光晴 
# Submission for 第3回課題2

require 'cgi'
cgi = CGI.new

print cgi.header("text/html; charset=utf-8")

# Initialize variables so they can be accessed after the begin block
question_array = Array.new
#Print error message if question.txt does not exist
question = "エラー: 質問が読み込めませんでした"

begin
  open("question.txt", "r:UTF-8") do |io|
    question = io.gets.chomp
    while line = io.gets.chomp
      question_array.push(line)
    end
  end
rescue => ex
  print <<EOS
  <html><body><pre>
    #{ex.message}
    #{CGI.escapeHTML(ex.backtrace.join("\n"))}
  </pre></body></html>
EOS
end

print <<EOF_HEADER
<html>
<head><meta charset="utf-8"><title>Voting System</title></head>
<body>
  <h1>投票システム</h1>
  <h2>#{question}</h2>
  <form action="vote.rb" method="post">
  #CGI library cannot handle empty form so we provide a guard
  <input type="hidden" name="guard" value="GUARD_VALUE_IGNORE_ME">
EOF_HEADER

question_array.each do |label_text|
  # The value attribute is essential for CGI to recieve option names
  puts "<input type=\"checkbox\" name=\"vote\" value=\"#{label_text}\"> #{label_text}<br>"
end

print <<EOF
    <br>
    <input type="reset" value="クリア">
    <input type="submit" value="送信">
  </form>
  <p><a href="view_result.rb">投票結果を見る</a></p>
</body>
</html>
EOF
