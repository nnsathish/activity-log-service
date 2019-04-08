require 'activity_log_seeder'

class ActivityLogsController < ApplicationController
  before_action :ensure_valid_csv_file, only: :upload

  # GET /api/activity_logs
  def index
    logs = ActivityLog.ordered.page(params[:page])
    render json: logs
  end

  # GET /api/activity_logs/state?object_id=1&object_type=Order
  def state
    log = ActivityLog.for_object(*state_args).last
    state = log.try!(:object_state) || {}
    render json: state
  end

  # POST /api/activity_logs/upload
  #   csv_file: Multipart form-data of csv file contents
  def upload
    ActivityLogSeeder.import!(params[:csv_file].tempfile) # background it for large files
    render json: { message: 'Uploaded successfully' }
  end

  private

  def state_params
    params.permit(:object_id, :object_type, :timestamp)
  end

  def state_args
    [state_params[:object_id], state_params[:object_type], state_params[:timestamp]]
  end

  def ensure_valid_csv_file
    file = params[:csv_file]
    valid = file.content_type == 'text/csv' # better to use gem like mimemagic
    unless valid
      render json: { error: 'Accepts only file with content type - text/csv' }, status: :bad_request
    end
  end
end
