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

selected_votes = cgi.params['vote'].map { |vote| vote.chomp }

# Error handling for empty input
if selected_votes.empty?
  print cgi.header("text/html; charset=utf-8")
  print <<EOF_EMPTY
    <html><body>
        <h1>エラー: 投票がありません</h1>
        <p>選択肢を一つ以上選んでください。</p>
        <a href="enquete_form.rb">投票に戻る</a>
    </body></html>
EOF_EMPTY
  exit
end

begin
    open("vote_result.txt", "a:UTF-8") do |data|
        # Lock file when writing
        data.flock(File::LOCK_EX)
        selected_votes.each do |vote|
            data.puts(vote)
        end
rescue => ex
    print cgi.header("text/html; charset=utf-8")
    print <<EOS_ERROR
    <html><body><pre>
        <h1>投票エラーが発生しました (ファイル書き込み失敗)</h1>
        #{ex.message}
    </pre></body></html>
EOS_ERROR
    exit
end

print cgi.header("text/html; charset=utf-8")
print <<EOF
<html><body>
<p>投票ありがとうございます。</p>
<br>
<a href="view_result.rb">投票結果を見る</a>
<br>
<a href="enquete_form.rb">投票に戻る</a>
<br>


</body></html>
EOF