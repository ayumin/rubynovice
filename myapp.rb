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
    @contacts.select! do |c|
      c =~ regex
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
    @name = params[:name]
    @mail = params[:mail]
    @tag = params[:tag]
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
  c = Contact.find(params[:id])
  c.set_params(params)
  c.save
  @contacts = Contact.all
  erb :index
end
