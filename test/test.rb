#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/json'
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

DB.create_table?(:post) do
  primary_key :id
  String :title
  Text :body
  DateTime :create_at
end

# make our model serializable
Sequel::Model.plugin :json_serializer

class Post < Sequel::Model

  def self.get_posts(bound=0, limit=32)
    if bound <= 0
      return Post.reverse_order(:id).limit(limit)
    else
      return Post.where{id < bound}.reverse_order(:id).limit(limit)
    end
  end

end

# sinatra
get '/list' do
  bound = if params[:bound] then params[:bound].to_i else 0 end
  @posts = Post.get_posts(bound)
  slim :index
end

get '/api/list' do
  bound = if params[:bound] then params[:bound].to_i else 0 end
  json Post.get_posts(bound)
end

get '/create' do
  slim :create
end

post '/api/create' do
  unless params[:title].empty? or params[:body].empty?
    Post.create(:title => params[:title], :body => params[:body], :create_at => Time.now)
  end
  redirect "/list", 303
end

