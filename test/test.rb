#!/usr/bin/env ruby

require 'sinatra'
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
  property :body, Text
end

DataMapper.finalize
DataMapper.auto_upgrade!

# sinatra
get '/' do
  @posts = Post.all(:order => [ :id.desc ], :limit => 20)
  erb :index
end

get '/:data' do
  unless params[:data].empty?
    Post.create(:body => params[:data])
  end
  "Post :)"
end

