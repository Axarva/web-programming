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

# Initialize hash with default value of empty array
selected_votes = Hash.new { |hash, key| hash[key] = [] }

# Insert votes array as values for question_id keys in selected_votes
cgi.params.each do |key, values|
  if key != 'guard' # Check if the key is NOT the 'guard' key        
    if key[0..4] == 'vote_' 
      question_id_string = key[5..-1] #Input name = vote_X where X = id.
      question_id = question_id_string.to_i 
      
      values.each do |option_text|
          selected_votes[question_id].push(option_text.chomp)
      end
    end
  end
end

# Error handling for empty votes
if selected_votes.empty?
  print <<EOF_EMPTY
    <html><body>
    <h1>エラー: 投票がありません</h1>
    <p>選択肢を一つ以上選んでください。</p>
    <a href="enquete_form2.rb">投票に戻る</a>
    </body></html>
EOF_EMPTY
  exit
end

# Add votes per question to database
begin
  db = SQLite3::Database.new("report1030.db")
  db.transaction(){
    selected_votes.each do |question, votes|
      votes.each do |vote|
        db.execute("INSERT INTO votes VALUES(?,?);", [question, vote])
      end
    end
  }
  db.close
rescue => ex
  print cgi.header("text/html; charset=utf-8")
  print <<EOS_ERROR
  <html><body><pre>
  <h1>投票エラーが発生しました (書き込み失敗)</h1>
  #{ex.message}
  </pre></body></html>
EOS_ERROR
exit
end

# Display HTML
print <<EOF
  <html><body>
  <p>投票ありがとうございました。</p>
  <br>
  <a href="view_result.rhtml">投票結果を見る</a><br>
  <a href="enquete_form2.rb">投票に戻る</a><br>
  </body></html>
EOF
