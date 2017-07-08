class InviteMailer < ApplicationMailer
  def guest_invitation(invite, cupping)
    @cupping = cupping
    @url =
      "https://www.coffeegrader.com/sign-up?inviteToken=#{invite.invite_token}"
    mail(to: invite.grader_email,
         subject: "#{host_name} invited you to a cupping!")
  end

  def user_invitation(invite, cupping)
    @cupping = cupping
    @invite = invite
    @url = "https://www.coffeegrader.com/users/#{@invite.grader_id}"
    mail(to: invited_grader.email,
         subject: "#{host_name} invited you to a cupping!")
  end

  private

  def host_name
    @host_name ||= User.find(@cupping.host_id).name if @cupping
  end

  def invited_grader
    @invited_grader ||= User.find(@invite.grader_id) if @invite
  end
end
