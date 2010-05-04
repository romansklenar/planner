class Bug < ActiveRecord::Base
  attr_accessible :name, :approved, :approved_at, :closed, :closed_at, :description, :note,
                  :reported_by, :task_id, :position, :actual_user, :proposed_user

  belongs_to :actual_user,   :class_name => "User"
  belongs_to :proposed_user, :class_name => "User"
  belongs_to :task

  acts_as_state_machine :initial => :active


  state :active, :enter => Proc.new { |bug|
      bug.approved_at = bug.closed_at = bug.actual_user_id = nil
      bug.approved = bug.closed = false
  }
  state :approved, :enter => Proc.new { |bug|
    bug.approved_at = Time.zone.now
    bug.approved = true
  }
  state :assigned, :enter => Proc.new { |bug|
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
    transitions :to => :approved, :from => [:active]
  end

  event :assign do
    transitions :to => :assigned, :from => [:approved]
  end

  event :close do
    transitions :to => :closed, :from => [:assigned, :active]
  end

end
