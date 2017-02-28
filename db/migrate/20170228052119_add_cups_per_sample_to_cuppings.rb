class AddCupsPerSampleToCuppings < ActiveRecord::Migration[5.0]
  def change
    add_column :cuppings, :cups_per_sample, :integer
  end
end
