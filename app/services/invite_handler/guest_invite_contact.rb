class InviteHandler
  class GuestInviteContact
    def self.build
      new
    end

    def call(invite, cupping)
      InviteMailer.guest_invitation(invite, cupping).deliver_later
    end
  end
end
