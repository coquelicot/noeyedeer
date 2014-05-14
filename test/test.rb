#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/json'
require 'data_mapper'

# settings
configure do

  # database
  set :dbuser, 'noeyedeer'
  set :dbpswd, 'iamfcrh>_^'
  set :dbname, 'noeyedeer'
  set :dbhost, 'localhost'

end

# DataMapper
DataMapper.setup(:default, "postgres://#{settings.dbuser}:#{settings.dbpswd}@#{settings.dbhost}/#{settings.dbname}")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :create_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!

# sinatra
get '/list' do
  json Post.all(:order => [ :id.desc ], :limit => 20)
end

get '/clean' do
  Post.all.destroy
end

get '/create/:title/:data' do
  unless params[:data].empty?
    Post.create(:title => params[:title], :body => params[:data], :create_at => Time.now)
  end
  "Post :)"
end

