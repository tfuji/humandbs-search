require 'open-uri'
require 'nokogiri'
require 'json'

url = 'https://humandbs.biosciencedbc.jp/hum0147-v3'

# urlにアクセスしてhtmlを取得する
html = URI.open(url).read


# 取得したhtmlをNokogiriでパースする
doc = Nokogiri::HTML.parse(html)
#pp doc

table = doc.css('table') 

table.each_with_index do |tb, ib|
  puts "## テーブル#{ib+1}個目"

  table_data = [] # この段階ではまだ1次元配列

  tb.css('tr:has(td)').each_with_index do |tr, ir|
    table_data[ir] = [] # 配列の要素単位に配列を作成する(二次元化)

    tr.css('td').each_with_index do |td, id|
      table_data[ir][id] = td.text.strip
    end
  end

  puts JSON.pretty_generate(table_data)

end
