require 'net/http'
require 'uri'
require 'thor'
require "json"
require "awesome_print"
require 'byebug'

TOKEN = ENV["DEVJOURNAL_TOKEN"]

class DevJournalCLI < Thor
  no_commands {
    def format_user response
      result = JSON.parse(response.body)
      ap "(n): #{result['first_name']} #{result['last_name']}"
      ap "(e): #{result['email']}"
      ap "(u): #{result['username']}"
    end

    def format_tasks response
      result = JSON.parse(response.body)
      ap "#{result.count} tasks"
      result.each do |task|
        ap "(id: #{task['id']}) #{task['name']} (Level: 2)"
      end
    end

    def format_task response
      result = JSON.parse(response.body)
      ap "(id: #{result['id']}) #{result['name']}"
    end
  }

  desc 'me', 'Retrieve user profile from DevJournal'
  def me
    uri = URI.parse("http://localhost:3000/api/v1/me")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Token token=#{TOKEN}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
    @current_user = JSON.parse(response.body)['id']
    format_user(response)
  end

  desc 'tasks', 'Retrieve tasks from DevJournal'
  def tasks
    uri = URI.parse("http://localhost:3000/api/v1/tasks")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Token token=#{TOKEN}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
    format_tasks(response)
  end

  desc 'add task', 'Add a task to DevJournal'
  def add name, level
    uri = URI.parse("http://localhost:3000/api/v1/tasks")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Token token=#{TOKEN}"
    request.body = "task[name]=#{name}&task[level]=#{level}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
    if response.code == 201
      format_tasks(response)
    else
      puts "Something went wrong: #{response.code}"
    end
  end

  desc 'task', 'Retrieve a task from DevJournal'
  def task id
    uri = URI.parse("http://localhost:3000/api/v1/tasks/#{id}")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Token token=#{TOKEN}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
    format_task(response)
  end
end

DevJournalCLI.start(ARGV)



