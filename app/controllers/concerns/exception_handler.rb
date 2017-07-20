module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, status: :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, status: :unprocessable_entity)
    end

    rescue_from Score::BatchInsertScoresError do |e|
      json_response({ message: e.message }, status: :bad_request)
    end

    rescue_from ActiveRecord::DeleteRestrictionError do |e|
      json_response({ message: e.message }, status: :forbidden)
    end
  end
end
