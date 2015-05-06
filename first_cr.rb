# -*- cpding: utf-8 -*-
require 'cgi'
require 'open-uri'

# page_source = open('samplepage.html', &:read)

def parse(page_source)
  # 日付取得
  dates = page_source.scan(
    %r!(¥d+)年 ?(¥d+)月 ?(¥d+)日<br/>!)
  # タイトル取得
  url_titles = page_source.scan(
    %r!^<a href="(.+?)">(.+?)</a><br/>!)
  # 各要素の対応を付ける
  url_titles.zip(dates).map{|(aurl, atitle),ymd|
    [CGI.unescapeHTML(aurl), CGI.unescapeHTML(atitle), Time.local(*ymd)]
  }
end
# x = parse(open("samplepage", &:read))
# X = parse(`/usr/bin/wget -q -O http://crawler.sbcr.jp/samplepage.html`)
# x[0,2]

def format_text(title, url, url_title_time_ary)
  s = "Title: #{title}¥nURL: #{url}¥n¥n"
  url_title_time_ary.each do |aurl, atitle, atime|
    s << "* (#{atime})#{atitle}¥n"
    s << "    #{aurl}¥n"
  end
  s
end

# puts format_text("WWW.SBCR トピックス",
#   "http://crawler.sbcr.jp/samplepage.html",
#   parse(`/usr/bin/wget -q -O http://crawler.sbcr.jp/samplepage.html`))
puts format_text("WWW.SBCR トピックス",
  "http://crawler.sbcr.jp/samplepage.html",
  parse(open("http://crawler.sbcr.jp/samplepage.html", "r:UTF-8", &:read)))
# or open("http://crawler.sbcr.jp/samplepage.html", &:read).toutf8