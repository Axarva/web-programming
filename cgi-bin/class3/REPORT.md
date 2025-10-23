# Webプログラミング提出レポート（第3回課題）

**学籍番号:** 202513228  
**氏名:** Timsina Atharva   
**担当教員:** 永森 光晴 先生  
**提出日:** 2025年10月23日  

---

## 1. 課題1: report3-1.rb（概要）

**目的:**  
sample3-1.txt 内の文字列の出現回数をカウントするRubyスクリプトを作成する。

**提出プログラム**  
```rb  
#!/usr/bin/env ruby  
# encoding: utf-8  
# 学籍番号: 202513228  
# 氏名: Timsina Atharva 
# 授業名: Webプログラミング  
# 教員名: 永森 光晴 先生
# 第3回課題1 提出プログラム  

open("sample3-1.txt", "r:UTF-8") do |io|  
  h = Hash.new(0)  
  while line = io.gets  
    key = line.chomp  
    h[key] += 1  
  end  
  h.sort.each { |key, value| print "#{key} = #{value}\n" }  
end  
```

**主な実装ポイント:**

- **カウント処理:**  
  `h = Hash.new(0)` により、デフォルト値0のハッシュを初期化。  

- **データ整形:**  
  各行の改行文字（\n）を `chomp` メソッドで削除。  

- **出力:**  
  スクリプトは以下を実行する：  
  1. 入力ファイルを読み込み  
  2. 各キーの出現回数を `h[key] += 1` で集計  
  3. アルファベット順にソートして整形出力  

```sh
scripts git:(main) ./report3-1.rb  
A = 14  
B = 11  
C = 6  
D = 2  
E = 1  
H = 1  
M = 1  
O = 1  
P = 1  
Q = 2  
R = 1  
W = 1  
X = 9  
Y = 4  
Z = 7  
```
---

## 2. 課題2: 投票システム

**提出プログラム:**

1. **enquete_form.rb**  

ノート：PDFに変更する場合よくレンダーされないため
```rb
  puts "<input type=\"checkbox\" name=\"vote\" value=\"\#{label_text}\">" "#{label_text}<br>"
```
を
```rb  
puts "<input type=\"checkbox\" name=\"vote\" value=\"#{label_text}\">" \
     "#{label_text}<br>"
```
として書いてあります。

```rb  
#!/usr/bin/env ruby  
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
```
---

2. **vote.rb**  
```rb  
#!/usr/bin/env ruby  
# encoding: utf-8  
# 学籍番号: 202513228  
# 氏名: Timsina Atharva 
# 授業名: Webプログラミング  
# 教員名: 永森 光晴 先生
# 第3回課題2 提出プログラム  

require 'cgi'  
cgi = CGI.new  
selected_votes = cgi.params['vote'].map { |vote| vote.chomp }  

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
<p>投票ありがとうございました。</p>  
<br>  
<a href="view_result.rb">投票結果を見る</a><br>  
<a href="enquete_form.rb">投票に戻る</a><br>  
</body></html>  
EOF  
```
---

3. **view_result.rb**  
```rb  
#!/usr/bin/env ruby  
# encoding: utf-8  
# 学籍番号: 202513228  
# 氏名: Timsina Atharva 
# 授業名: Webプログラミング  
# 教員名: 永森 光晴 先生
# 第3回課題2 提出プログラム  

require 'cgi'  
cgi = CGI.new  
print cgi.header("text/html; charset=utf-8")  

result_hash = Hash.new(0)  
vote_total = 0  
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
<head><meta charset="utf-8"><title>投票システム</title></head>  
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
```
---

**ファイルと機能の対応表**

| ファイル名 | 役割 | 主な機能 |
|-------------|------|-----------|
| enquete_form.rb | 投票フォームを表示 | question.txt から質問と選択肢を読み込み、CGIクラッシュ防止用の隠し入力（guard）を利用 |
| vote.rb | 投票データを保存 | 入力を検証後、vote_result.txt に書き込み。排他ロック (flock) を使用 |
| view_result.rb | 投票結果を表示 | 投票結果を読み込み、`Hash.new(0)` で集計し、総数と各項目を出力 |

---

## 3. 改善点および拡張機能

### CGIパーサクラッシュ防止（ガードパラメータ）

**問題点:**  
RubyのCGIライブラリは、POSTボディが空の場合（チェックボックスが全て未選択の場合）に  
`TypeError: can't convert nil into Integer  `
という例外を発生させる。

**解決策:**  
次のような隠しパラメータを追加した：  
`<input type="hidden" name="guard" value="GUARD_VALUE_IGNORE_ME">`

**効果:**  
これによりPOSTリクエストのボディが空になることがなく、`CGI.new` の初期化が確実に成功。  
`if selected_votes.empty?` による入力検証で安全に処理可能。

---

## 4. 授業へのフィードバック・質問

- 授業の内容は非常に理解しやすくて、学ぶことも楽しいです。
- 授業内容に関して質問は特にありませんが、これからの課題提出ではこのようなレポートも含まれる場合レポートを英語で書いてもよろしいでしょうか。

---