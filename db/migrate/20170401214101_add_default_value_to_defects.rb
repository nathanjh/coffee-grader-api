class AddDefaultValueToDefects < ActiveRecord::Migration[5.0]
  def change
    change_column_default :scores, :defects, from: nil, to: 0
  end
end
