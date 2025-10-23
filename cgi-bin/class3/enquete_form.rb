#!/home/satellanutella/.rbenv/shims/ruby
# encoding: utf-8
# 学籍番号: 202513228
# 氏名: Timsina Atharva
# 授業名: Webプログラミング
# 教員名: 永森 光晴 先生
# 第3回課題2 提出プログラム
require 'cgi'
cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
question_array = Array.new
question = "エラー: 質問が読み込めませんでした"
begin
open("question.txt", "r:UTF-8") do |io|
question = io.gets.chomp
while line = io.gets
question_array.push(line.chomp)
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
<head><meta charset="utf-8"><title>投票システム</title></head>
<body>
<h1>投票システム</h1>
<h2>#{question}</h2>
<form action="vote.rb" method="post">
<input type="hidden" name="guard" value="GUARD_VALUE_IGNORE_ME">
EOF_HEADER
question_array.each do |label_text|
  puts "<input type=\"checkbox\" name=\"vote\" value=\"#{label_text}\">" \
     "#{label_text}<br>"
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
