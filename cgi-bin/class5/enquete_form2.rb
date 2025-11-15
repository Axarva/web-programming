#!/home/satellanutella/.rbenv/shims/ruby
# encoding: utf-8
# 学籍番号: 202513228
# 氏名: Timsina Atharva
# 授業名: Webプログラミング
# 教員名: 永森 光晴 先生
# 第4回課題2 提出プログラム
require 'cgi'
require 'sqlite3'

cgi = CGI.new
print cgi.header("text/html; charset=utf-8")

# Initialize global variables
question_array = Array.new

begin
    print <<EOF_HEADER
      <html>
      <head><meta charset="utf-8"><title>投票システム</title></head>
      <body>
        <h1>投票システム</h1>
        <form action="vote2.rb" method="post">
          <input type="hidden" name="guard" value="GUARD_VALUE_IGNORE_ME">
EOF_HEADER
    # Database block
    SQLite3::Database.new("report1030.db") do |db|
      db.transaction(){
        # Select question values from questions table
        question_array = db.execute("SELECT id, question FROM questions;")
        question_array.each do |question_id, question|
          puts "<h2>#{question}</h2>"
          # Select options for each question based on question ID
          options_array = db.execute("SELECT option FROM options WHERE question_id = ?;", [question_id])
          options_array.each do |row|
            option_text = row[0]
            print "<input type='checkbox' name='vote_#{question_id}' value='#{option_text}'>#{option_text}<br>\n"          
          end
          print "<hr>\n"
        end
      }
    end
      print <<EOB
      <br>
      <input type="reset" value="クリア">
      <input type="submit" value="送信">
      </form>
      <p><a href="view_result.rhtml">投票結果を見る</a></p>
      </body>
      </html>
EOB

rescue => ex
print <<EOS
  <html><body><pre>
  #{ex.message}
  #{CGI.escapeHTML(ex.backtrace.join("\n"))}
  </pre></body></html>
EOS
end
