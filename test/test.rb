#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/json'
require 'sinatra/content_for'
require 'coffee-script'
require 'sequel'
require 'slim'

# settings
configure do

  # server binding
  set :port, 8880
  set :bind, '0.0.0.0'

  # database
  set :dbuser, 'noeyedeer'
  set :dbpswd, 'iamfcrh>_^'
  set :dbname, 'noeyedeer'
  set :dbhost, 'localhost'

  # static folder
  set :public_folder, File.dirname(__FILE__) + '/public'

end

# Sequel
DB = Sequel.connect("postgres://#{settings.dbhost}/#{settings.dbname}", :user => settings.dbuser, :password => settings.dbpswd)

DB.create_table?(:posts) do
  primary_key :id
  String :user
  Text :body
  DateTime :create_at
end

# make our model serializable
Sequel::Model.plugin :json_serializer

class Post < Sequel::Model

  def self.get_posts(low_bound=nil, high_bound=nil, limit=32)
    request = Post
    request = request.where{id > low_bound} if low_bound
    request = request.where{id < high_bound} if high_bound
    return Post.reverse_order(:id).limit(limit)
  end

end

# sinatra
get '/chat/?' do
  slim :chat
end

get '/noeyedeer/:id.js' do
  coffee params[:id].to_sym
end

get '/api/chat' do
  json Post.get_posts(params[:low_bound], params[:high_bound])
end

post '/api/chat' do
  unless params[:user].empty? or params[:body].empty?
    Post.create(:user => params[:user], :body => params[:body], :create_at => Time.now)
  end
  "Sent"
end

