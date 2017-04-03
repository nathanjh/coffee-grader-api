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

  # In case we run into performance issues with creating multiple scores...
  # it'll be interesting to test either way...
  # MUST ENSURE VALID PARAMS FOR SCORES! this method WILL save invalid scores
  def self.import(scores)
    return unless scores.any?

    values = scores.map do |score|
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

    query = <<-SQL
    SAVEPOINT batch_insert_savepoint;
    INSERT INTO scores (cupped_coffee_id, cupping_id, roast_level, aroma, aftertaste, acidity, body, uniformity, balance, clean_cup, sweetness, overall, defects, total_score, notes, created_at, updated_at, grader_id, final_score, flavor) VALUES
    #{values.join(',')}
    SQL
    begin
      connection.execute(query)
    rescue ActiveRecord::StatementInvalid
      # TODO: Raise error to catch and rescue with excepionhandler in controller!
      # Rails.logger.info('Invalid params; did not create batch records')
      # puts "SQL error in #{__method__}"
      connection.execute('ROLLBACK TO SAVEPOINT batch_insert_savepoint')
      raise BatchInsertScoresError
    ensure # perhaps use ensure, as we don't want this savepoint to persist
      connection.execute('RELEASE SAVEPOINT batch_insert_savepoint')
    end
  end

  # Exception class to handle bulk import errors--passed off to ExceptionHandler
  # controller concern to generate json response.
  class BatchInsertScoresError < ActiveRecord::StatementInvalid
    def initialize(msg = 'There was a probelm with one or more of the score parameters. Unable to save scores to the database.')
      super
    end
  end
end
