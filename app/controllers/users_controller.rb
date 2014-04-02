class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    # GET /users
    render :json => { 
      :success => 'true', 
      :data => User.all
    }.to_json
  end

  def show
    # GET /users/:id
    if User.exists? id: params[:id]
      render :json => { 
        :success => 'true', 
        :data => User.find(params[:id])
      }.to_json
    else
      render :json => { 
        :success => 'false', 
      }.to_json
    end
  end

  def create
    # POST /users
    if params[:password] == params[:confirmpassword]
      u = User.new
      u.username = params[:username]
      u.password = params[:password]
      u.email = params[:email]
      
      saved = false
      if u.save
        saved = true
      end
    end

    if saved
        render :json => { 
          :success => 'true', 
          :data => u
        }.to_json
      else
        render :json => { 
          :success => 'false'
        }.to_json
    end
  end

  def update
    # PUT /users/:id
    u = User.find(params[:id])
    if params[:username]
      u.username = params[:username]
    end
    if params[:password]
      u.password = params[:password]
    end
    if params[:email]
      u.password ||= params[:email]
    end


    saved = false
    if u.save
      saved = true
    end

    if saved
        render :json => { 
          :success => 'true', 
          :data => u
        }.to_json
      else
        render :json => { 
          :success => 'false'
        }.to_json
    end
  end

  def destroy
    # DELETE /users/:id
    if User.exists? id: params[:id]
      User.find(params[:id]).destroy
      render :json => { 
        :success => 'true', 
      }.to_json
    else
      render :json => { 
        :success => 'false', 
      }.to_json
    end
  end

  def login
    # POST /users/:username
    u = User.find_by_username(params[:username])
    if u and u.password == params[:password]
      render :json => { 
        :success => 'true',
        :data => u
      }.to_json
    else
      render :json => { 
        :success => 'false', 
      }.to_json
    end
  end
end
