#!/home/satellanutella/.rbenv/shims/ruby
#!/usr/bin/env ruby
# encoding: utf-8
# Student ID: 202513228
# Student name: Atharva Timsina
# Class: Web Programming
# Professor: 永森 光晴 
# 第7回課題2
require 'cgi'
cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
begin
  data = open("bbsdata.txt", "r:UTF-8")
  messages = CGI.escapeHTML(data.read)
  data.close
rescue => ex
  print <<EOS
    <html><body><pre>
    #{ex.message}
    #{CGI.escapeHTML(ex.backtrace.join("\n"))}
    </pre></body></html>
EOS
end

print <<EOF
<html>
<head>
  <meta charset="utf-8">
  <title>Simple BBS</title>
  <script>
    // Checker for empty input
    function pre_check(elementId, errorMsg) {
      var domElement = document.getElementById(elementId).value
      var ret;
      if (domElement.length > 0) {
        ret = true;
      } else {
        ret = false; alert(errorMsg);
      }
      return ret;
    }

    // Checker for HTML tag occurance
    function validate_no_html(elementId, errorMsg) {
      var domElement = document.getElementById(elementId);
      
      // 1. <       : Starts with <
      // 2. \/?     : Optional / (for closing tags)
      // 3. [a-zA-Z]: Must start with a letter (avoids math like "5 < 10")
      // 4. [^>]*   : Match anything else until...
      // 5. >       : Closing >
      var htmlTagPattern = /<\\s*\\/?[a-zA-Z][^>]*>/;

      if (domElement && htmlTagPattern.test(domElement.value)) {
        alert(errorMsg);
        return false;
      }
      return true;
    }

    // Check all requirements
    function check_submit() {
      // Check Name is not empty
      if (!pre_check("name_id", "名前を入力してください")) {
        return false;
      }

      // Check Body is not empty
      if (!pre_check("message_id", "本文を入力してください")) {
        return false;
      }

      // Check Body for HTML tags
      if (!validate_no_html("message_id", "HTMLのタグは使えません")) {
        return false;
      }

      // If we get here, all checks passed
      return true;
    }
  </script>
</head>
<body>
  <h1>１行掲示板 </h1>
  <p>メッセージをどうぞ。</p>

  <form action="update.rb" method="post" onsubmit="return check_submit()">
      <span>メッセージ: </span>
      <textarea id="message_id" name="message" rows="1" cols="60" placeholder="Write a message"></textarea>
      <br>

      <span>お名前: </span>
      <input id="name_id" type="text" name="name" placeholder="Name">
      <br>
      <input type="submit" value="書き込む">
      <input type="reset" value="クリア">
  </form>
  <hr>
  <pre>
#{messages}
  </pre>
</body>
</html>
EOF
