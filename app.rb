# Blog
require "sinatra"
require "sinatra/activerecord"
require './lib/models.rb'
require './lib/helpers.rb'

set :database, "sqlite3:///articles.db"

class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 3 }
  validates :body, presence: true
end

# sass splat
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
  @title = "HG Business Law LLP"
  erb :index
end

get '/services' do
  @title = "HG Business Law LLP - Our Services"
  erb :services
end

get '/pricing' do
  @title = "HG Business Law LLP - Pricing Options"
  erb :pricing
end

get '/about' do
  @title = "About HG Business Law LLP"
  erb :about
end

get '/terms' do
  @title = "HG Business Law LLP - Terms"
  erb :terms
end

get '/articles/' do
  @title = "HG Business Law LLP - Articles"
  @posts = Post.order("created_at DESC")
  erb :"articles/index"
end


helpers do
  # If @title is assigned, add it to the page's title.
  def title
    if @title
      "#{@title} -- My Blog"
    else
      "My Blog"
    end
  end

  # Format the Ruby Time object returned from a post's created_at method
  # into a string that looks like this: 06 Jan 2012
  def pretty_date(time)
    time.strftime("%d %b %Y")
  end

  # Show "Edit Post" and "Delete Post" if viewing a post
  def post_show_page?
    request.path_info =~ /\/articles\/\d+$/
  end

  # delete post button
  def delete_post_button(post_id)
    erb :_delete_post_button, locals: { post_id: post_id}
  end

end

# Get the New Post form
get "/articles/new" do
  @title = "New Post"
  @post = Post.new
  erb :"articles/new"
end

# The New Post form sends a POST request (storing data) here
# where we try to create the post it sent in its params hash.
# If successful, redirect to that post. Otherwise, render the "posts/new"
# template where the @post object will have the incomplete data that the
# user can modify and resubmit.
post "/articles/" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "articles/#{@post.id}"
  else
    erb :"articles/new"
  end
end

# Get the individual page of the post with this ID.
get "/articles/:id" do
  @post = Post.find(params[:id])
  @title = @post.title
  erb :"articles/show"
end

# Get the Edit Post form of the post with this ID.
get "/articles/:id/edit" do
  @post = Post.find(params[:id])
  @title = "Edit Form"
  erb :"articles/edit"
end

# The Edit Post form sends a PUT request (modifying data) here.
# If the post is updated successfully, redirect to it. Otherwise,
# render the edit form again with the failed @post object still in memory
# so they can retry.
put "/articles/:id" do
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    redirect "/articles/#{@post.id}"
  else
    erb :"articles/edit"
  end
end

# Deletes the post with this ID and redirects to homepage.
delete "/articles/:id" do
  @post = Post.find(params[:id]).destroy
  redirect "/articles/"
end