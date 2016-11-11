require 'thor'
require 'httparty'

TOKEN = ENV[:DEVJOURNAL_TOKEN]

class DevJournalCLI < Thor
  include HTTParty
  base_uri = 'http://localhost:3000/api/v1/'

  desc 'me', 'returns user information from DevJournal'
  def me
    data = self.class.get('/me', query: {api_key: TOKEN})
    puts data.parsed_response
  end

  desc 'tasks', 'returns list of unfinished tasks from DevJournal'
  def tasks
    data = self.class.get('/tasks', query: {api_key: TOKEN})
    puts data.parsed_response
  end
end

DevJournalCLI.start(ARGV)