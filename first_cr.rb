# -*- cpding: utf-8 -*-
require 'cgi'

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

x = parse(open("samplepage", &:read))


x[0,2]