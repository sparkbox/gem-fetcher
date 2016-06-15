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

class GemGetter

  def self.fetch
    loop do
      puts $last_ts
      break if !get_messages($last_ts)
    end

    File.open('public/data/gems-approved.json', 'w')  do |f|
      f.write $messages.reverse.to_json
    end
  end


  def self.get_messages(ts)
    data = $client.channels_history(channel: "#{$cid}", count: 1000, latest: ts, inclusive: true)
    messages = data["messages"]
    puts "We have #{messages.count} messages starting at '#{ts}' time"
    messages.each do |message|
      has_public = false
      disapproved = false
      start_text = ""
      text = ""
      if reactions = message["reactions"]
        reactions.each do |r|
          if  /^earth_*/.match(r["name"])
            has_public = true
            user_name = $users[message["user"]]
            text = message["text"].inspect
            if user_name == "gem-me-bot"
              start_text = ""
            else
              start_text = "#{user_name}: "
            end
            if users_mentioned = text.scan(/\<\@(U[A-Z0-9]+)\>/)
              users_mentioned.each do |u|
                user_mention = $users[u[0]]
                puts user_mention
                text = text.sub("<@#{u[0]}>", "@#{user_mention}")
              end
            end
          end
          if  /^x/.match(r["name"])
            disapproved = true
          end
        end
        if has_public and !disapproved
          $messages.push("#{start_text}#{text}")
          puts "gem count #{$messages.count}"
        end
      end
    $last_ts = message["ts"]
    end

    data["has_more"]
  end
end
