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

questions = Array.new

begin
  print <<EOF_HEADER
  <html>
  <head><meta charset="utf-8"><title>投票システム</title></head>
  <body>
  <h1>投票結果</h1>
EOF_HEADER
  SQLite3::Database.new("report1030.db") do |db|
    db.transaction(){
      questions = db.execute("SELECT id, question FROM questions;")

      questions.each do |qid, question|
        result_tally = db.execute("SELECT COUNT(*) FROM votes WHERE question_id = ?;", [qid])
        result_total = result_tally[0][0]
        results = db.execute("SELECT question_id, name, COUNT(*) FROM votes WHERE question_id = ? GROUP BY name", [qid])
        print <<EOF_BODY
        <h2>#{question}</h2>
        <p>投票数 = #{result_total}</p>
        <ul>
EOF_BODY
        results.each do |result|
          result_text = result[1]
          result_count = result[2]
          puts "<li> #{result_text}: #{result_count}</li>"
        end
        print "</ul><br>"
      end
    }
  end

rescue => ex
  print <<EOS
    <html><body><pre>
    #{ex.message}
    #{CGI.escapeHTML(ex.backtrace.join("\n"))}
    </pre></body></html>
EOS
end

print <<EOF
  <p><a href="enquete_form2.rb">投票に戻る</a></p>
  </body>
  </html>
EOF
