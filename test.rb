require "json"
json_file = 'public/memos.js'

memos_json = JSON.parse(File.read(json_file))

# memos_json.each do |id, value|
#   puts "id:#{id} タイトル:#{value['title']}"
# end

id = (memos_json.keys.max.to_i + 1).to_s
new_memo = {"title" => "メモ5","content" => "メモ5内容"}
memos_json[id] = new_memo

File.open(json_file, "w") do |file|
  JSON.dump(memos_json,file)
end