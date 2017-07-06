class AddGraderEmailAndInviteTokenToInvites < ActiveRecord::Migration[5.0]
  def change
    add_column :invites, :grader_email, :string
    add_column :invites, :invite_token, :string
  end
end
