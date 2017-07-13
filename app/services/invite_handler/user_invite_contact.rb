class InviteHandler
  class UserInviteContact
    def self.build
      new
    end

    def call(invite, cupping)
      InviteMailer.user_invitation(invite, cupping).deliver_later
    end
  end
end
