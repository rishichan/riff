# app/sidekiq/email_worker.rb
class EmailWorker
  include Sidekiq::Worker
  sidekiq.options retry: 2  # Number of retries if job fails

  def perform(user_id)
    UserMailer.verification_email(user_id).deliver_now
  end
end
