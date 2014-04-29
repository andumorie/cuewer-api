require 'nexmo'

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
    if u and u.password == params[:password] and u.code == '1'
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

  def send_code
    # POST /users/send_code/:username
    u = User.find_by_username(params[:username])
    if u
      u.number = params[:number]
      cod = 0
      loop do
        cod = (10**5 + rand(10**6 - 10**5)).to_s(10)
        break if !User.find_by_code(cod)
      end
      u.code = cod

      nexmo = Nexmo::Client.new('81dfd0fe', '7b51e610')
      response = nexmo.send_message({ :to => params[:number], 
                                      :from => 'Cuewer', 
                                      :text => 'Welcome to Cuewer! Your activation code is: ' + cod
                                    })

      if response.ok?
        if u.save
          render :json => { 
            :success => 'true',
          }.to_json
        else
          render :json => { 
            :success => 'false', 
          }.to_json
        end
      else
        render :json => { 
          :success => 'false', 
        }.to_json
      end

    else
      render :json => { 
          :success => 'false', 
        }.to_json
    end
  end

  def validate_code
    # POST /users/validate_code/:code
    u = User.find_by_code(params[:code])
    if u
      u.code = '1';
      if (u.save)
        render :json => { 
          :success => 'true',
          :data => u
        }.to_json
      else
        render :json => { 
          :success => 'false', 
        }.to_json
      end
    else
      render :json => { 
        :success => 'false', 
      }.to_json
    end
  end

  def get_contacts
    # GET /users/get_contacts/:username
    u = User.find_by_username(params[:username])
    if u
      numbers = params[:numbers]
      if numbers
        numbers.each do |number|
          f = User.find_by_number(number)
          if f and f.code == '1' and u != f
            # add him as a friend if he's not already
            if !u.friends.include?(f)
              u.friends << f
              u.save
            end
            if !f.friends.include?(u)
              f.friends << u
              f.save
            end
          end
        end
      end
      render :json => { 
        :success => 'true',
        :data => u.friends.as_json
      }.to_json
    else
      render :json => { 
        :success => 'false', 
      }.to_json
    end
  end

end
