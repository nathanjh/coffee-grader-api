class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
      t.references :cupped_coffee, foreign_key: true
      t.references :grader, foreign_key: true
      t.references :cupping, foreign_key: true
      t.integer :roast_level
      t.decimal :aroma, precision: 4, scale: 2
      t.decimal :aftertaste, precision: 4, scale: 2
      t.decimal :acidity, precision: 4, scale: 2
      t.decimal :body, precision: 4, scale: 2
      t.decimal :uniformity
      t.decimal :balance, precision: 4, scale: 2
      t.decimal :clean_cup
      t.decimal :sweetness
      t.decimal :overall, precision: 4, scale: 2
      t.integer :defects
      t.decimal :total_score
      t.text :notes

      t.timestamps
    end
  end
end
