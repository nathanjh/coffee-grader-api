class ScoresController < CuppingDependentController
  before_action :find_score, only: [:show, :update, :destroy]
  before_action :check_cupping_status, only: [:create, :update, :destroy]

  # GET /scores
  def index
    @scores = Score.all
    json_response(@scores)
  end

  # GET /scores/id
  def show
    json_response(@score)
  end

  # POST /scores
  def create
    @score = Score.create!(score_params)
    json_response(@score, :created)
  end

  # POST /scores/submit_scores
  def submit_scores
    @scores = scores_params[:scores].map { |score| Score.new(score) }
    Score.import(@scores)
    head :no_content
  end

  # PATCH /scores/:id
  def update
    @score.update!(score_params)
    head :no_content
  end

  # DELETE /scores/:id
  def destroy
    @score.destroy
    head :no_content
  end

  private

  def score_params
    params.require(:score).permit(:cupped_coffee_id, :cupping_id, :roast_level,
                                  :aroma, :aftertaste, :acidity, :body,
                                  :uniformity, :balance, :clean_cup, :sweetness,
                                  :overall, :defects, :total_score, :notes,
                                  :grader_id, :flavor, :final_score)
  end

  def scores_params
    params.permit(scores: [:cupped_coffee_id, :cupping_id,
                           :roast_level, :aroma, :aftertaste,
                           :acidity, :body, :uniformity,
                           :clean_cup, :sweetness, :overall,
                           :defects, :total_score, :notes,
                           :grader_id, :flavor, :final_score,
                           :created_at, :updated_at, :balance])
  end
end
