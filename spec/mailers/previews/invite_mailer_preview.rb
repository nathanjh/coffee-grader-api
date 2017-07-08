# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview
  def guest_invitation
    cupping = Cupping.last
    # ensure that we have a guest_invite to use...
    invite =
      cupping.invites.build(grader_email: Faker::Internet.unique.email,
                            invite_token: SecureRandom.urlsafe_base64(16))
    InviteMailer.guest_invitation(invite, cupping)
  end

  def user_invitation
    cupping = Cupping.first
    invite = cupping.invites.first
    InviteMailer.user_invitation(invite, cupping)
  end
end
