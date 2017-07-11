class InviteHandler
  def self.build
    new(GuestInviteContact.build, UserInviteContact.build)
  end

  def initialize(guest_invite_contact, user_invite_contact)
    self.guest_invite_contact = guest_invite_contact
    self.user_invite_contact = user_invite_contact
  end

  def call(invite, cupping)
    if invite.grader_id.blank?
      invite.update!(invite_token: generate_token)
      guest_invite_contact.call(invite, cupping)
    else
      user_invite_contact.call(invite, cupping)
    end
  end

  private

  attr_accessor :guest_invite_contact, :user_invite_contact

  def generate_token
    SecureRandom.urlsafe_base64(16)
  end
end
