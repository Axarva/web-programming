#!/usr/bin/env ruby
# encoding: utf-8
# Student ID: 202513228
# Student name: Atharva Timsna
# Class: Web Programming
# Professor: 永森 光晴
# Submission for 第3回課題1
open("sample3-1.txt", "r:UTF-8") do |io|
  h = Hash.new(0)
  while line = io.gets
    key = line.chomp
    h[key] += 1
  end
  h.sort.each { |key, value|
    print "#{key} = #{value}\n"
  }
end
