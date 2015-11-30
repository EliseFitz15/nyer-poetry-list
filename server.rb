require "sinatra"
require "pg"
require "pry"
require 'open-uri'
require 'nokogiri'
require 'sinatra/flash'
require_relative 'config/application'

configure :development do
  set :db_config, { dbname: "poetry_list_development" }
end

configure :test do
  set :db_config, { dbname: "poetry_list_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

def crawl_new_yorker_mag(params)
  @url = params[:url]
  doc = Nokogiri::HTML(open(@url)) do |config|
    config.noblanks.nonet
  end
end

def poem_save(title, author, body, url)
  db_connection do |conn|
    sql_query = "INSERT INTO poems (title, author, body, url) VALUES ($1, $2, $3, $4)"
    data = [title, author, body, url]
    conn.exec_params(sql_query, data)
  end
end

def poem_titles
  db_connection do |conn|
    sql_query = "SELECT id, title FROM poems;"
    conn.exec(sql_query)
  end
end

def find_poem(params)
  poem_id = params["id"]
  db_connection do |conn|
    sql_query = "SELECT title, author, body from poems WHERE id = $1"
     conn.exec_params(sql_query, [poem_id])
  end
end

get "/poems" do
  @poems = poem_titles
  erb :index
end

get "/new_poem" do
  erb :new
end

post "/new_poem" do
  if params["url"].include?("newyorker.com")
    page = crawl_new_yorker_mag(params)
    title = page.css("#masthead h1").text
    body = page.css(".poetry p")
    author = page.css("#masthead h3")
    poem_save(title, author, body, params["url"])
    redirect "/poems"
  else
    flash[:notice] = "Please include link from New Yorker Magazine (www.newyorker.com/magazines/poems)"
    redirect "/new_poem"
  end
end

get "/poems/:id" do
  @poem = find_poem(params)

  erb :show
end
