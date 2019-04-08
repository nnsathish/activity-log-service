class ActivityLog < ApplicationRecord
  validates :object_id, :object_type, :timestamp, presence: true

  scope :ordered, -> { order(:timestamp) }
  scope :for_object, -> (object_id, object_type, timestamp = nil) {
    cond = where(object_id: object_id, object_type: object_type)
    cond = cond.where('timestamp <= ?', timestamp.to_i) if timestamp.present?
    cond.ordered
  }

  before_save :compute_object_state

  def prev_state
    @prev_state ||= ActivityLog.for_object(self.object_id, self.object_type).last
    @prev_state.try!(:object_state)
  end

  private

  def compute_object_state
    self.object_state = begin
      last_state = self.prev_state || {}
      last_state.merge(object_changes)
    end
  end
end
