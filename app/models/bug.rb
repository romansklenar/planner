class Bug < ActiveRecord::Base
  attr_accessible :name, :actual_worker, :approved, :approved_at, :closed, :closed_at, :description, :note, :proposed_worker, :reported_by, :task_id, :position
end
