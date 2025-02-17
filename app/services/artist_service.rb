require_relative "../api/helpers/auth_helper"
require "faraday"

class ArtistService
  extend AuthHelper

  def self.signup(params)
    res = signup_details("artist", params)
    artist = Artist.new(
      username: params[:username],
      email: params[:email],
      emailVerified: false,
      password_digest: res[:pass]
    )

    if artist.save
      EmailWorker.perform_async("Artist", artist.id, res[:verification_link])
      { message: "Verification mail sent. Please verify.", status: 200 }
    else
      { error: artist.errors.full_messages, status: 400 }
    end
  end

  def self.verify_email(token)
    decoded = JWT.decode(token, ENV["SECRET_KEY"])
    artist = Artist.find_by(email: decoded[0])

    if artist
      artist.update(emailVerified: true)
      { message: "Email verified", status: 200 }
    else
      { error: "Invalid token", status: 400 }
    end
  end

  def self.login(params, session, cookies)
    artist = Artist.find_by(username: params[:username])
    return { error: "User not found", status: 400 } unless artist
    return { error: "Email not verified", status: 400 } unless artist.emailVerified
  
    if BCrypt::Password.new(artist.password_digest) == params[:password_digest]
      session[:artist_id] = artist.id
      session[:type] = :artist
      data = { :session_id => session.id, :user_id => artist.id, :user_type => :artist }.to_json
      encrypted_data = generateJwt(data)      
      cookies[:artist_session] = {
        value: encrypted_data,
        path: '/api/v1/artist', 
        httponly: true,         
      }
      cookies[:music_session_artist] = {
        value: encrypted_data,
        path: '/api/v1/music', 
        httponly: true,         
      }
  
      { message: "Login successful", artist_id: session[:artist_id], status: 200 }
    else
      { error: "Invalid password", status: 400 }
    end
  end

  def self.upload_music(file)
    return { error: "No file uploaded", status: 400 } unless file
    return { error: "Only audio files allowed", status: 400 } unless file[:type] == 'audio/mpeg'
    max_size = 10 * 1024 * 1024 # 10MB
    return { error: "Files bigger then 10MB not allowed", status: 400 } unless file[:tempfile].size <= max_size
    result = upload_file(file)
    result
  end

  def self.upload_file(file)
    require "faraday"
    Faraday.default_connection_options = {
      ssl: { ca_file: File.join(Dir.pwd, "cacert.pem") }
    }

    result = Cloudinary::Uploader.upload(file[:tempfile].path, resource_type: :video, verify_ssl: false)
    if result["secure_url"]
      { url: result["secure_url"], public_id: result["public_id"], status: 200 }
    else
      { error: "Upload failed", status: 500 }
    end
  end

  def self.create_music(title, artist_id, mp3link)
    music = Music.new(
      title: title,
      artist_id: artist_id,
      mp3link: mp3link
    )    
    if music.save
      { message: "Music uploaded", status: 200 }
    else
      { error: music.errors.full_messages, status: 400 }
    end
  end

  def self.delete_artist(params)
    return { message: "Not authorized to delete", status: 400} if params[:artist_id]!=params[:current_user_id]
    artist = Artist.find(params[:artist_id])
    error!('Artist not found', 404) unless artist
    if artist.destroy
      { message: "Account deleted", status: 200 }
    else
      { error: artist.errors.full_messages, status: 400 }
    end
  end

  def self.update_music(params)
    return { message: "Not authorized to update", status: 400} if params[:artist_id]!=params[:current_user_id]
    music = Music.find(params[:music_id])
    error!('Music not found', 404) unless music
    return { message: "Failed to update",status: 400 } unless music.update!(params.except(:music_id, :artist_id, :mp3link, :current_user_id))
    { message: "Music updated successfully", music: music }
  end

  def self.update_artist(params)
    return { message: "Not authorized to update", status: 400} if params[:artist_id]!=params[:current_user_id]
    artist = Artist.find(params[:artist_id])
    error!('Artist not found', 404) unless artist
    return { message: "Failed to update",status: 400 } unless artist.update!(params.except(:artist_id, :email, :password_digest, :current_user_id, :emailVerified))
    { message: "Artist updated successfully", artist: artist }
  end

  def self.delete_music(params)
    music = Music.find(params[:music_id])
    error!('Music not found', 404) unless music
    return { message: "Not authorized to update", status: 400} if music[:artist_id]!=params[:current_user_id]
    if music.destroy
      { message: "Music file deleted", status: 200 }
    else
      { error: music.errors.full_messages, status: 400 }
    end
  end
end
