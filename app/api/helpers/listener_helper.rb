module ListenerHelper
  def signup_listener(params)
    result = ListenerService.signup(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def verify_listener_email(token)
    result = ListenerService.verify_email(token)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def login_listener(params, session, cookies)
    result = ListenerService.login(params, session, cookies)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def update_listener(params)
    result = ListenerService.update_listener(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def delete_listener(params)
    result = ListenerService.delete_listener(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def subscribe_artist(params)
    result = ListenerService.subscribe_artist(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def unsubscribe_artist(params)
    result = ListenerService.unsubscribe_artist(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end

  def get_user_history(params)
    result = ListenerService.get_user_history(params)
    error!(result[:error], result[:status]) if result[:error]
    result.except(:status)
  end
end
