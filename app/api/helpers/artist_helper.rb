module ArtistHelper
  def signup_artist(params)
    result = ArtistService.signup(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def verify_artist_email(token)
    result = ArtistService.verify_email(token)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def login_artist(params, session, cookies)
    result = ArtistService.login(params, session, cookies)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def update_artist(params)
    result = ArtistService.update_artist(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def upload_music(params)
    uploadResult = ArtistService.upload_music(params[:file])
    error!(uploadResult[:error], uploadResult[:status]) if uploadResult[:error]
    result = ArtistService.create_music(params[:title], params[:artist_id], uploadResult[:url])
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def delete_artist(params)
    result = ArtistService.delete_artist(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def update_music(params)
    result = ArtistService.update_music(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def delete_music(params)
    result = ArtistService.delete_music(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end
end
