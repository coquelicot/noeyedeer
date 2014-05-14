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

end

# Sequel
DB = Sequel.connect("postgres://#{settings.dbhost}/#{settings.dbname}", :user => settings.dbuser, :password => settings.dbpswd)

DB.create_table?(:post) do
  primary_key :id
  String :title
  Text :body
  DateTime :create_at
end

class Post < Sequel::Model
end

# sinatra
get '/list' do
  @posts = Post.reverse_order(:id).limit(20)
  slim :index
end

get '/api/list' do
  json Post.reverse_order(:id).limit(20)
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

