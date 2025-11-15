#!/home/satellanutella/.rbenv/shims/ruby
# encoding: utf-8
# 学籍番号: 202513228
# 氏名: Timsina Atharva
# 授業名: Webプログラミング
# 教員名: 永森 光晴 先生
# 第5回課題3 提出プログラム

require 'cgi'

cgi = CGI.new

# Cookie setup
cookies = cgi.cookies
win_count = (cookies["wins"][0] || 0).to_i
loss_count = (cookies["losses"][0] || 0).to_i
draw_count = (cookies["draws"][0] || 0).to_i

print cgi.header("type" => "text/html", "charset" =>"utf-8")

print <<EOF_HEADER
      <html>
      <head><meta charset="utf-8"><title>じゃんけん</title></head>
      <body>
        <h1>じゃんけん</h1>
        <p>現在の勝敗：#{win_count}　勝　#{loss_count}　敗　#{draw_count}　分け　</p>
        
        <form action="judge_cookie.rb" method="post">
          今度の手は？
          <input type="hidden" name="guard" value="GUARD_VALUE_IGNORE_ME">
          <input type='radio' name='option' value='グー'>グー
          <input type='radio' name='option' value='チョキ'>チョキ
          <input type='radio' name='option' value='パー'>パー
          <input type="submit" value="勝負！">
          
        </form>
        <form action="judge_cookie.rb" method="post">
          <input type="hidden" name="cookiereset" value="COOKIE_RESET">
          <input type="submit" value="勝敗をリセット">
        </form>
EOF_HEADER
