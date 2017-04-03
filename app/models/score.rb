class Score < ApplicationRecord
  belongs_to :grader, foreign_key: 'grader_id', class_name: 'User'
  belongs_to :cupped_coffee
  belongs_to :cupping

  validates_presence_of :grader_id,
                        :cupping_id,
                        :cupped_coffee_id,
                        :aroma,
                        :aftertaste,
                        :acidity,
                        :body,
                        :uniformity,
                        :flavor,
                        :balance,
                        :clean_cup,
                        :sweetness,
                        :overall,
                        :defects,
                        :total_score,
                        :final_score

  # Database constraints ensure that no bad scores are saved
  def self.import(scores)
    return unless scores.any?
    values = score_values(scores)

    begin
      connection.execute(build_query(values))
    rescue ActiveRecord::StatementInvalid
      connection.execute('ROLLBACK TO SAVEPOINT batch_insert_savepoint')
      raise BatchInsertScoresError
    ensure
      connection.execute('RELEASE SAVEPOINT batch_insert_savepoint')
    end
  end

  # Exception class to handle bulk import errors--passed off to ExceptionHandler
  # controller concern to generate json response.
  class BatchInsertScoresError < ActiveRecord::StatementInvalid
    ERROR_MESSAGE = <<-MSG
    There was a probelm with one or more of the score parameters. Unable to save scores to the database.
    MSG
                    .freeze

    def initialize(msg = ERROR_MESSAGE)
      super
    end
  end

  # to add private class helper methods for Score
  class << self
    private

    def score_values(scores)
      scores.map do |score|
        sanitize_sql_array(
          ['(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
           score.cupped_coffee_id, score.cupping_id, score.roast_level,
           score.aroma, score.aftertaste, score.acidity, score.body,
           score.uniformity, score.balance, score.clean_cup, score.sweetness,
           score.overall, score.defects, score.total_score, score.notes,
           DateTime.now, DateTime.now, score.grader_id, score.final_score,
           score.flavor]
        )
      end
    end

    def build_query(values)
      <<-SQL
      SAVEPOINT batch_insert_savepoint;
      INSERT INTO scores (cupped_coffee_id, cupping_id, roast_level, aroma, aftertaste, acidity, body, uniformity, balance, clean_cup, sweetness, overall, defects, total_score, notes, created_at, updated_at, grader_id, final_score, flavor) VALUES
      #{values.join(',')}
      SQL
    end
  end
end
