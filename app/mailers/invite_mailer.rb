class InviteMailer < ApplicationMailer
  def guest_invitation(invite, cupping)
    # @invite = invite
    @cupping = cupping
    @url =
      "https://www.coffeegrader.com/sign-up?inviteToken=#{invite.invite_token}"
    mail(to: invite.grader_email,
         subject: "#{host_name} invited you to a cupping!")
  end

  private

  def host_name
    @host_name ||= User.find(@cupping.host_id).name if @cupping
  end
end
