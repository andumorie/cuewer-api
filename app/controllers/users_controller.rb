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
      user = User.new
      user.username = params[:username]
      user.password = params[:password]
      user.email = params[:email]
      
      saved = false
      if user.save
        saved = true
      end
    end

    if saved
        render :json => { 
          :success => 'true', 
          :data => user
        }.to_json
      else
        render :json => { 
          :success => 'false'
        }.to_json
    end
  end

  def update
    # PUT /users/:id
    user = User.find(params[:id])
    if params[:username]
      user.username = params[:username]
    end
    if params[:password]
      user.password = params[:password]
    end
    if params[:email]
      user.password ||= params[:email]
    end


    saved = false
    if user.save
      saved = true
    end

    if saved
        render :json => { 
          :success => 'true', 
          :data => user
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
end
