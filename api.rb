require 'sinatra'
require 'rack/conneg'
require 'json'
require 'yaml'
require 'gyoku'

use(Rack::Conneg) { |conneg|
  conneg.set :accept_all_extensions, false
  conneg.set :fallback, :json
  # conneg.ignore('/stylesheets/')
  # conneg.ignore_contents_of(File.join(File.dirname(__FILE__),'public'))
  conneg.provide([:json, :xml, :yaml, :text, :html])
}

before do
  if negotiated?
    content_type negotiated_type
  end
end

messages = [
  "No",
  "Not today",
  "It is decidedly so",
  "Without a doubt",
  "Yes definitely",
  "You may rely on it",
  "As I see it yes",
  "Most likely",
  "Outlook good",
  "Signs point to yes",
  "Reply hazy try again",
  "Ask again later",
  "Better not tell you now",
  "Cannot predict now",
  "Concentrate and ask again",
  "Don't count on it",
  "My reply is no",
  "My sources say no",
  "Outlook not so good",
  "Very doubtful"
]

get '/' do
  "Hello World!"
end

get '/answer' do
  response = { :message => messages.sample }
  respond_to do |wants|
    wants.json { response.to_json }
    wants.xml { Gyoku.xml(response) }
    wants.yaml { YAML.dump(response) }
    wants.text { response[:message] }
    wants.html { erb :api, :locals => { :response => response } }
    wants.other { 
      content_type 'text/plain'
      error 406, "Not Acceptable" 
    }
  end
end