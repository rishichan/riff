require "bcrypt"

module AuthHelper
  extend Grape::API::Helpers

  def hash_pass(pass)
    BCrypt::Password.create(pass)
  end

  SECRET_KEY = ENV["SECRET_KEY"]
  def generateJwt(data)
    JWT.encode(data, SECRET_KEY)
  end

  BASE_URL = ENV["BASE_URL"]
  def generateVerificationLink(user_type, token)
    "#{BASE_URL}/api/v1/#{user_type}/verify_email?token=#{token}"
  end

  def current_id(user_type)
    cookie_name = "#{user_type}_session".to_sym
    cookie_value = cookies&.[](cookie_name)
    return nil if cookie_value.nil?
    res = JWT.decode(cookie_value, SECRET_KEY)
    return nil unless res
    user_session = JSON.parse(res[0] || "{}", symbolize_names: true)
    @current_user_id = user_session[:user_id] if user_session[:user_type]&.to_sym == user_type.to_sym
    return @current_user_id

    rescue JWT::ExpiredSignature
      cookies.delete(cookie_name)
      nil
    rescue JWT::DecodeError
      cookies.delete(cookie_name)
      nil
    rescue JWT::VerificationError
      cookies.delete(cookie_name)
      nil
    nil
  end

  def authenticate_user(user_type)
    error!("Unauthorized", 401) unless current_id(user_type)
    true
  end

  def auth_for_music(user_type)
    cookie_name = "music_session_#{user_type}".to_sym
    cookie_value = cookies&.[](cookie_name)
    return false if cookie_value.nil?
    res = JWT.decode(cookie_value, SECRET_KEY)
    return false unless res
    music_session_user = JSON.parse(res[0] || "{}", symbolize_names: true)
    return music_session_user[:user_type]&.to_sym == user_type.to_sym 
    rescue JWT::ExpiredSignature
      cookies.delete(cookie_name)
      false
    rescue JWT::DecodeError
      cookies.delete(cookie_name)
      false
    rescue JWT::VerificationError
      cookies.delete(cookie_name)
      false
  end

  def signup_details(user_type, params)
    pass = hash_pass(params[:password_digest])
    verification_token = generateJwt(params[:email])
    verification_link = generateVerificationLink(user_type, verification_token)
    { pass: pass, verification_token: verification_token, verification_link: verification_link }
  end
end
