class Task < ApplicationRecord
  validates :title, presence: true

  broadcasts_to ->(task) { "tasks" }, inserts_by: :prepend

  enum :status, {
    pending: "pending",
    in_progress: "in_progress",
    completed: "completed"
  }

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :pending
  end
end
