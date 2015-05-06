# -*- cpding: utf-8 -*-
require 'cgi'
require 'open-uri'
require 'rss'

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
# puts format_text("WWW.SBCR トピックス",
#   "http://crawler.sbcr.jp/samplepage.html",
#   parse(open("http://crawler.sbcr.jp/samplepage.html", "r:UTF-8", &:read)))
# or open("http://crawler.sbcr.jp/samplepage.html", &:read).toutf8

parsed = parse(open("http://crawler.sbcr.jp/samplepage.html", "r:UTF-8", &:read))

def format_rss(title, url, url_title_time_ary)
  RSS::Maker.make("2.0") do |maker|
    maker.channel.updated = Time.now.to_s
    maker.channel.link = url
    maker.channel.title = title
    maker.channel.description = title
    url_title_time_ary.each do |aurl, atitle, atime|
      maker.items.new_item do |item|
        itme.link = aurl
        item.title = atitle
        item.updated = atime
        item.description = atitle
      end
    end
  end
end

formatter = case ARGV.first
  when "rss-output"
    :format_rss
  when "text-output"
    :format_text
  end
puts __send__(formatter,
  "WWW.SBCR トピックス",
  "http://crawler.sbcr.jp/samplepage.html",
  parsed)