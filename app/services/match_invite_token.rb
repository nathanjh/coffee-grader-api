class MatchInviteToken
  def self.build
    new
  end

  # is it best for this method to just fail silently if no token is found on
  # invites table?
  def call(user)
    return unless user.invite_token
    invite = Invite.find_by_invite_token(user.invite_token)
    invite.update!(grader_id: user.id) if invite
  end
end
