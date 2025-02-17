# app/sidekiq/email_worker.rb
class EmailWorker
  include Sidekiq::Worker
  # sidekiq.options retry: 2

  def perform(user_type, user_id, verification_link)
    logger.info "Sending email to user with id: #{user_id} and #{verification_link}"
    user = user_type.constantize.find_by(id: user_id)
    return logger.info "❌ #{user_type} not found: #{user_id}" if user.nil?

    UserMailer.verification_email(user, verification_link).deliver_now
  end
end
