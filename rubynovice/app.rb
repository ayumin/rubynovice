$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'rubygems'
require 'sinatra'
require 'active_record'
require 'model/contact'
require 'erb'

configure :development do
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :dbfile => 'db/development.sqlite3'
  )
end

get '/' do
  @contacts = Contact.all
  unless params[:key] == ""
    regex = /#{params[:key]}/
    @contacts = @contacts.select do |c|
      str = c.name   ? c.name  : ""
      str += c.email ? c.email : ""
      str += c.tag   ? c.tag   : ""
      str =~ regex
    end
  end
  erb :index
end
get '/new' do
  erb :new
end
get '/:id' do
  @contact = Contact.find(params[:id])
  erb :show
end
class Contact
  def set_params params
    self.name = params[:name]
    self.email = params[:email]
    self.tag = params[:tag]
  end  
end
post '/' do
  c = Contact.new
  c.set_params(params)
  c.save
  @contacts = Contact.all
  erb :index
end
post '/:id' do
  p "(USER LOG) :#{params[:id]}" 
  p "(USER LOG) :#{params[:name]}" 
  p "(USER LOG) :#{params[:email]}" 
  p "(USER LOG) :#{params[:tag]}" 
  c = Contact.find(params[:id])
  c.set_params(params)
  c.save
  @contacts = Contact.all
  erb :index
end
get '/about' do
  "I'm running version " + Sinatra::VERSION
end
