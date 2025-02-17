require_relative "../api/helpers/auth_helper"
require "faraday"

class ListenerService
  extend AuthHelper

  def self.signup(params)
    res = signup_details("listener", params)
    listener = Listener.new(
      username: params[:username],
      email: params[:email],
      emailVerified: false,
      password_digest: res[:pass]
    )
  
    if listener.save
      EmailWorker.perform_async("Listener", listener.id, res[:verification_link])
      { message: "Verification mail sent. Please verify.", status: 200 }
    else
      { error: listener.errors.full_messages, status: 400 }
    end
  end

  def self.verify_email(token)
    decoded = JWT.decode(token, ENV["SECRET_KEY"])
    listener = Listener.find_by(email: decoded[0])

    if listener
      listener.update(emailVerified: true)
      { message: "Email verified", status: 200 }
    else
      { error: "Invalid token", status: 400 }
    end
  end

  def self.login(params, session, cookies)
    listener = Listener.find_by(username: params[:username])
    return { error: "User not found", status: 400 } unless listener
    return { error: "Email not verified", status: 400 } unless listener.emailVerified

    if BCrypt::Password.new(listener.password_digest) == params[:password_digest]
      session[:listener_id] = listener.id
      session[:type] = :listener
      data = { :session_id => session.id, :user_id => listener.id, :user_type => :listener }.to_json
      encrypted_data = generateJwt(data)
      cookies[:listener_session] = {
        value: encrypted_data,
        path: '/api/v1/listener', 
        httponly: true,         
      }
      cookies[:music_session_listener] = {
        value: encrypted_data,
        path: '/api/v1/music', 
        httponly: true,         
      }
      { message: "Login successful", listener_id: session[:listener_id], status: 200 }
    else
      { error: "Invalid password", status: 400 }
    end
  end

  def self.delete_listener(params)
    byebug
    return { message: "Not authorized to delete", status: 400} if params[:listener_id]!=params[:current_user_id]
    listener = Listener.find(params[:listener_id])
    byebug
    error!('Listener not found', 404) unless listener
    if listener.destroy
      { message: "Account deleted", status: 200 }
    else
      { error: listener.errors.full_messages, status: 400 }
    end
  end

  def self.update_listener(params)
    return { message: "Not authorized to update", status: 400} if params[:listener_id]!=params[:current_user_id]
    listener = Listener.find(params[:listener_id])
    error!('Listener not found', 404) unless listener
    return { message: "Failed to update",status: 400 } unless listener.update!(params.except(:listener_id, :email, :password_digest, :current_user_id, :emailVerified))
    { message: "Listener updated successfully", listener: listener }
  end

  def self.subscribe_artist(params)
    listener = Listener.find(params[:listener_id])
    artist = Artist.find(params[:artist_id])
    return { error: "Listener not found", status: 404 } unless listener
    return { error: "Artist not found", status: 404 } unless artist
    subscription  = Subscription.new(listener_id: listener.id, artist_id: artist.id)
    if subscription.save
      { message: "Subscribed to artist", status: 200 }
    else
      { error: subscription.errors.full_messages, status: 400 }
    end
  end

  def self.unsubscribe_artist(params)
    listener = Listener.find(params[:listener_id])
    artist = Artist.find(params[:artist_id])
    return { error: "Listener not found", status: 404 } unless listener
    return { error: "Artist not found", status: 404 } unless artist
    
    subscription = Subscription.find_by(listener_id: listener.id, artist_id: artist.id)
    return { error: "Subscription not found", status: 404 } unless subscription
    
    if subscription.destroy
      { message: "Unsubscribed from artist", status: 200 }
    else
      { error: subscription.errors.full_messages, status: 400 }
    end
  end

  def self.get_user_history(params)
    history = ListeningHistory.where(listener_id: params[:listener_id]) 
    return { message: "No history found", status: 400} unless history
    {history: history}
  end
end