class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :entity_not_found

  private
  def entity_not_found
    render json: { error: "not found" }, status: :not_found
  end
end
