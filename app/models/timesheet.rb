class Timesheet < ActiveRecord::Base
  attr_accessible :task_id, :user_id, :started_at, :finished_at, :note

  belongs_to :user
  belongs_to :task

  validate :starts_and_ends_on_validations
  validates_presence_of :user, :task, :started_at, :finished_at


  protected
  
  def started_and_finished_date_validations
    errors.add_to_base("start time is later than finish time") if started_at > finished_at
  end
end
