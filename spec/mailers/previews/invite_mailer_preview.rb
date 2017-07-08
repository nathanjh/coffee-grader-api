# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview
  def guest_invitation
    cupping = Cupping.last
    invite = cupping.invites.first
    InviteMailer.guest_invitation(invite, cupping)
  end
end
