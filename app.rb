require './lib/models.rb'
require './lib/helpers.rb'

get '/stylesheets/*.css' do
  content_type 'text/css', :charset => 'utf-8'
  filename = params[:splat].first
  scss "#{filename}.css".to_sym, :views => "lib/assets/stylesheets"
end


get '/styles.css' do
	  scss :styles
end

# Set up root path and use the index view
get '/' do
  erb :index
end

# Page Routes
get '/index' do
  erb :index
end

get '/services' do
  erb :services
end

get '/pricing' do
  erb :pricing
end

get '/about' do
  erb :about
end

get '/terms' do
  erb :terms
end