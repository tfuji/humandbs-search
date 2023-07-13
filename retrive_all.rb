#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'open-uri'
require 'nokogiri'

def parse (list_file)        
  @csv_rows = Hash.new { |h,k| h[k] = {} }
  CSV.foreach("#{list_file}",col_sep: ",", headers: true) do |row|
    ids = row[0].split(/\s+/)
    humID = ids.shift
    h = row.to_hash
    h['identifier'] = humID
    h['type'] = 'humandbs-research'
    h['dbXrefs'] = ids
    h["molecular_data"] = retrive_moldata humID.gsub('.','-'), lang="ja"
    @csv_rows[humID] = h
  end
  @csv_rows
end

###
def retrive_moldata id, lang
  #url = 'https://humandbs.biosciencedbc.jp/hum0147-v3'
  url = "https://humandbs.biosciencedbc.jp/#{id}"
  url = "https://humandbs.biosciencedbc.jp/en/#{id}" if lang =="en"
  warn url
  html = URI.open(url).read
  doc = Nokogiri::HTML.parse(html)
  items = Hash.new(0)
  table = doc.css('table') 

  moldata_table =[]
  table.each_with_index do |tb, ib|
    table_data = [] # この段階ではまだ1次元配列
    moldata_flag = false

    tb.css('tr:has(td)').each_with_index do |tr, ir|
      table_data[ir] = [] # 配列の要素単位に配列を作成する(二次元化)

      tr.css('td').each_with_index do |td, id|
        table_data[ir][id] = td.text.strip
        items[td.text.strip] += 1 if id == 0
        moldata_flag = true if td.text.strip == "対象"
      end
    end
    if moldata_flag
      #puts "## テーブル#{ib+1}個目" if moldata_flag
      #puts JSON.pretty_generate(table_data) if moldata_flag
      moldata_table.push(table_data)
    end
  end
  moldata_table
end
###


hash = parse(ARGV.shift)
puts  JSON.pretty_generate(hash)
