#!/usr/bin/env ruby
# encoding: utf-8
require 'sqlite3'
data = [
  [202012501, "Sugimoto Tabata"],
  [202012502, "Tabata Someone"],
  [202012503, "Your mom"]
]

db = SQLite3::Database.new("test.db") do |db|
  db.transaction() {
    data.each{|i|
      db.execute("INSERT INTO mytbl
                 VALUES(?,?);", [i[0],i[1]])
    }
    db.execute("SELECT * FROM mytbl;") {|row|
      printf("%9d: %s\n", row[0], row[1])
    }
  }
  db.close
end
