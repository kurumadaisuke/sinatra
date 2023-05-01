require "json"
json_file = 'public/memos.js'

memos_json = JSON.parse(File.read(json_file))

memos_json.each do |id, value|
  puts "id:#{id} タイトル:#{value['title']}"
end