require 'net/http'
require 'uri'
require 'thor'

TOKEN = ENV["DEVJOURNAL_TOKEN"]

class DevJournalCLI < Thor
  desc 'me', 'Retrieve user profile from DevJournal'
  def me
    uri = URI.parse("http://localhost:3000/api/v1/me")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Token token=#{TOKEN}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
    puts response.body
  end

  desc 'tasks', 'Retrieve tasks from DevJournal'
  def tasks
    uri = URI.parse("http://localhost:3000/api/v1/tasks")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Token token=#{TOKEN}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
    puts response.body
  end
end

DevJournalCLI.start(ARGV)