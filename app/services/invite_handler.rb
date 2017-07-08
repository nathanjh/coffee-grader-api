class InviteHandler
  def self.build
    new
  end

  def call(invite)
    if invite.grader_id.blank?
      invite.update!(invite_token: generate_token)
      # to interact with dbs from the mailer)
      # call mailer service (no user account for grader)
    else
      # call mailer service (user account for grader)
    end
  end

  private

  def generate_token
    SecureRandom.urlsafe_base64(16)
  end
end
