class Bug < ActiveRecord::Base
  attr_accessible :name, :approved, :approved_at, :closed, :closed_at, :description, :note,
                  :reported_by, :task_id, :position, :actual_worker, :proposed_worker

  belongs_to :actual_worker,   :class_name => "User"
  belongs_to :proposed_worker, :class_name => "User"
  belongs_to :task

  acts_as_state_machine :initial => :active

  state :active, :enter => Proc.new { |bug|
      bug.approved_at = bug.closed_at = bug.actual_worker_id = nil
      bug.approved = bug.closed = false
  }

  state :approved, :enter => Proc.new { |bug|
    bug.approved_at = Time.zone.now
    bug.approved = true
  }

  state :delegated, :enter => Proc.new { |bug|
    raise ArgumentError, "Cannot delegate bug, no proposed user defined" if bug.proposed_worker.nil?
    Task.create_from_bug(bug) if bug.task.nil?
  }

  state :closed, :enter => Proc.new { |bug|
    bug.closed_at = Time.zone.now
    bug.closed = true
  }


  event :activate do
    transitions :to => :active, :from => [:approved]
  end

  event :approve do
    transitions :to => :approved, :from => [:active, :closed]
  end

  event :delegate do
    transitions :to => :delegated, :from => [:active, :closed]
  end

  event :close do
    transitions :to => :closed, :from => [:approved, :activate]
  end

end
