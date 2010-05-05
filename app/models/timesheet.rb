class Timesheet < ActiveRecord::Base
  attr_accessible :task_id, :user_id, :started_at, :finished_at, :note
end
