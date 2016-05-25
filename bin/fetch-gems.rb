require "slack"
require "yaml"
require "dotenv"
require "pathname"
require "fileutils"
Dotenv.load

token = ENV["TOKEN"] || (print "Token: "; gets.strip)
$client = Slack::Client.new token: token

# Get users list
puts 'fetching latest data...'
$users = Hash[$client.users_list["members"].map{|m| [m["id"], m["name"]]}]
$cid = "C02V6AFJP"  # This is the GEMS channel
$last_ts = ''
$more = true
$messages = []
def get_messages(ts)
  data = $client.channels_history(channel: "#{$cid}", count: 1000, latest: ts, inclusive: true)
  messages = data["messages"]
  puts "We have #{messages.count} messages starting at '#{ts}' time"
  messages.each do |message|
    user_name = $users[message["user"]]
    text = message["text"].inspect
    if /\<\@(U[A-Z0-9]+)\>/.match(text)
      users_mentioned = text.scan(/\<\@(U[A-Z0-9]+)\>/)
      users_mentioned.each do |u|
        user_mention = $users[u[0]]
        text = text.sub("<@#{u[0]}>", "@#{user_mention}")
      end
      $messages.push("#{user_name}: #{text}")
    end
    $last_ts = message['ts']
  end
  data["has_more"]
end

loop do
  puts $last_ts
  break if !get_messages($last_ts)
end

File.open('public/data/gems.json', 'w')  do |f|
  f.write $messages.to_json
end
