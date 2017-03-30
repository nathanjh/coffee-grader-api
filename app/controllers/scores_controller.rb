class ScoresController < CoffeeGraderApiController
  before_action :find_score, only: [:show, :update, :destroy]

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

  def find_score
    @score = Score.find(params[:id])
  end

  def score_params
    params.permit(:cupped_coffee_id, :cupping_id, :roast_level, :aroma, :aftertaste, :acidity, :body, :uniformity, :balance, :clean_cup, :sweetness, :overall, :defects, :total_score, :notes, :grader_id, :flavor, :final_score)
  end
end
