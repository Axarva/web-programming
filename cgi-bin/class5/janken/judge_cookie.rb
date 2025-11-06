#!/home/satellanutella/.rbenv/shims/ruby
# encoding: utf-8
# 学籍番号: 202513228
# 氏名: Timsina Atharva
# 授業名: Webプログラミング
# 教員名: 永森 光晴 先生
# 第5回課題3 提出プログラム

require 'cgi'
cgi = CGI.new

cookies = cgi.cookies
user_hand = cgi.params['option'].first

if user_hand.nil?
  print cgi.header("text/html; charset=utf-8")
  print <<EOF_EMPTY

    <html><body>
    <h1>エラー: 手が選択されていません</h1>
    <p>選択肢を一つ選んでください。</p>
    <p><a href="janken_cookie.rb">もう一度勝負する？</a></p>
    </body></html>
EOF_EMPTY
  exit
end


win_count = (cookies["wins"][0] || 0).to_i
loss_count = (cookies["losses"][0] || 0).to_i
draw_count = (cookies["draws"][0] || 0).to_i


HANDS = { 0 => 'グー', 1 => 'チョキ', 2 => 'パー'}
user_val = HANDS.key(user_hand)
comp_val = rand(3)
comp_hand = HANDS[comp_val]

result = user_val.to_i - comp_val.to_i
# -2 is loss
# -1 is win
# 0 is draw
# 1 is loss
# 2 is win
result_code = (result + 3) % 3 #This makes 0 = draw, 1 = loss, 2 = win

case result_code
when 0
    # 引き分け
    draw_count += 1
    result_text = "引き分け"
when 1
    # 負け
    loss_count += 1
    result_text = "負け"
when 2
    # 勝ち
    win_count += 1
    result_text = "勝ち"
end

new_cookies = []
new_cookies.push(CGI::Cookie.new("name" => "wins", "value" => win_count.to_s))
new_cookies.push(CGI::Cookie.new("name" => "losses", "value" => loss_count.to_s))
new_cookies.push(CGI::Cookie.new("name" => "draws", "value" => draw_count.to_s))


print cgi.header("type" => "text/html", "charset" => "utf-8", "cookie" => new_cookies)
print <<EOF
<html>
<head>
  <meta charset="utf-8">
  <title>勝負！</title>
</head>
<body>
  <h1>勝負！</h1>
  
  <p>あなた: #{user_hand}</p>
  <p>コンピュータ: #{comp_hand}</p>
  
  <div>
    #{result_text}
  </div>
    <p>現在の勝敗：
    <span>#{win_count}</span> 勝　
    <span>#{loss_count}</span> 敗　
    <span>#{draw_count}</span> 分け
    </p>
  
  <p><a href="janken_cookie.rb">もう一度勝負する？</a></p>

</body>
</html>
EOF
