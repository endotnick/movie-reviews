# Manages user-based routing, helpers, sessions
class UsersController < ApplicationController
  get '/login' do
    redirect "/users/#{current_user.id}" if logged_in?
    @error = params[:error]
    erb :'/users/login.html'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  end
    redirect '/signup?error=Invalid form submission, please try again:'
  end

  post '/logout' do
    session.destroy
    redirect :/
  end

  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    redirect back unless @user
    erb :'/users/show.html'
  end

  get '/signup' do
    redirect "/users/#{current_user.id}" if logged_in?
    @error = params[:error]
    erb :'/users/new.html'
  end

  # create new user
  post '/signup' do
    if params.values.any?(&:empty?) ||
                        User.find_by(username: params[:username]) ||
                        User.find_by(email: params[:email])
      redirect '/signup?error=Invalid form submission, please try again:'
    end
    # there's no way that posting a clear password like this is secure
    User.create(
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )
    redirect :login
  end
end
