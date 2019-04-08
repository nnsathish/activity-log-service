class ApplicationController < ActionController::API
  def health_check
    head :no_content
  end
end
