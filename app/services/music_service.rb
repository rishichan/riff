class MusicService
  def self.get_music(artist_id)
    return { error: "Artist not found", status: 404 } unless Music.exists?(artist_id: artist_id) 
    music = Music.where(artist_id: artist_id)
    { music: music }
  end

  def self.get_top_music
    res = ListeningHistory.group(:music_id)
      .order('count_music_id DESC')
      .limit(10)
      .count('music_id')    
    music = Music.where(id: res.keys)
    { music: music }
  end

  def self.search_music(keyword)
    music = Music.where("LOWER(title) LIKE LOWER(?)", "%#{keyword}%")
    { music: music }
  end

  def self.add_history(params)
    return { error: "Music not found", status: 404 } unless Music.exists?(params[:music_id])
    return { error: "Listener not found", status: 404 } unless Listener.exists?(params[:listener_id])
    history = ListeningHistory.new(music_id: params[:music_id], listener_id: params[:listener_id])
    if history.save
      { history: history }
    else
      { error: history.errors.full_messages, status: 400 }
    end
  end
end