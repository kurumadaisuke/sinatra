require "json"
json_file = 'public/memos.js'

memos_json = JSON.parse(File.read(json_file))

memos_json.each do |id, value|
  puts value['title']
end
# puts memos_json['1']['title']

# @title = memos_json.values.map { |memo| memo['title'] }