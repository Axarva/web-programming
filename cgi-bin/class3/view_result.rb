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
result_hash = Hash.new(0)
vote_total = 0
#Print error message if question.txt does not exist
question = "エラー: 質問が読み込めませんでした"

begin
  open("question.txt", "r:UTF-8") do |io|
    question = io.gets.chomp
  end
  open("vote_result.txt", "r:UTF-8") do |votes|
  while line = votes.gets
    key = line.chomp
    result_hash[key] += 1
  end
  vote_total = result_hash.values.sum
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
  <h1>投票結果</h1>
  <h2>#{question}</h2>
  <p>投票数 = #{vote_total}</p>
  <ul>
EOF_HEADER

result_hash.each do |label_text, count|
  puts "<li> #{label_text}: #{count}</li>"
end

print <<EOF
  </ul>
  <p><a href="enquete_form.rb">投票に戻る</a></p>
</body>
</html>
EOF
