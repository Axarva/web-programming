#!/usr/bin/env ruby
# encoding: utf-8
print "Pattern: "
pattern = STDIN.gets.chomp
regexp = Regexp.new(pattern, false)
#regexp = Regexp.new(pattern, true)

# gets は実行時に引数として与えられたファイルから
# 一行読み込んだ文字列を返す組み込み関数。
while line = gets
  if regexp =~ line
    print line
  end
end

# ruby sample6-2.rb meibo.txt
# • 以下を検索する正規表現を考え、sample6-2.rb使って結果を確認する
# 1. 「SATOH」か「SAITOH」を含む
# 2. 「ヒデユキ」か「ヒロユキ」を含む
# 3. 「サ」で始まる
# 4. 「ナ」か「サ」で始まり、「ユキ」を含む
# 5. 空白以外の同じ文字の繰り返しを含む

# 1. SAI?TOH
# 2. ヒ[デロ]ユキ
# 3. ^サ
# 4. ^[サナ].*?ユキ.*?
# 5. (\S)\1 
# 
#  以下の条件を検索する正規表現を考える
# 1. 偶数にマッチする正規表現
# – 2, 10, 2020, 008等，数字全体にマッチする
# – ＋/−の符号は考慮しない
# – 先頭に余分なゼロが付いていてもよい
# Answer: ^[0-9]*?[02468]$, \b[0-9]*?[02468]\b
# 2. 郵便番号にマッチする正規表現
# – 郵便番号は3桁の数字と4桁の数字をハイフンで
# 結んだ7桁の番号とする（例：305-8550）
# – ただし，ハイフンは省略可能
# – 正規表現「Go{5}al!」は"Goooooal!"にマッチする
# Answer: ^[0-9]{3}-?[0-9]{4}$, \b[0-9]{3}-?[0-9]{4}\b
# 
# Assignment 3
# Basic answer (not including 'll'): ^st.*?(\S)\1.*?l$
# Answer for extra points (includes 'll' on top of basic answer): ^st.*?((\S)\2.*?|l)l$
