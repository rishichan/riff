module MusicHelper
  def get_music(artist_id)
    result = MusicService.get_music(artist_id)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def get_top_music
    result = MusicService.get_top_music
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def search_music(keyword)
    result = MusicService.search_music(keyword)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def add_history(params)
    result = MusicService.add_history(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end
end