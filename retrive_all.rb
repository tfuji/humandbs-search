#!/usr/bin/env ruby

require 'csv'
require 'json'

def parse (list_file)        
  @csv_rows = Hash.new { |h,k| h[k] = {} }
  CSV.foreach("#{list_file}",col_sep: ",", headers: true) do |row|
    ids = row[0].split(/\s+/)
    humID = ids.shift
    h = row.to_hash
    h['identifier'] = humID
    h['type'] = 'humandbs-research'
    h['dbXrefs'] = ids
    @csv_rows[humID] = h 
  end
  @csv_rows
end

hash = parse(ARGV.shift)
puts  JSON.pretty_generate(hash)
