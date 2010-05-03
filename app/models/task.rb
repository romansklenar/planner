class Task < ActiveRecord::Base
  attr_accessible :name, :completed_at, :checked_at, :due_to, :scheduled_to, :project
  attr_protected  :completed, :checked
  
  belongs_to :project

  default_scope :order => 'position ASC'
  named_scope :incomplete, :conditions => { :completed => false }
  named_scope :completed, :conditions => { :completed => true }
  named_scope :recently_completed, :conditions => { :completed => true }, :order => 'completed_at DESC', :limit => 15

  validates_presence_of :name, :project


  acts_as_list :scope => :project
  acts_as_taggable
  acts_as_state_machine :initial => :active


  state :active,    :enter => Proc.new { |task| task.completed_at = task.checked_at = nil; task.completed = task.checked = false }
  state :completed, :enter => Proc.new { |task| task.completed_at = Time.zone.now; task.completed = true }
  state :checked,   :enter => Proc.new { |task| task.checked_at = Time.zone.now; task.checked = true }


  event :activate do
    transitions :to => :active, :from => [:completed, :checked]
  end
  
  event :complete do
    transitions :to => :completed, :from => [:active]
  end

  event :check do
    transitions :to => :checked, :from => [:completed]
  end


  def completed?
    state == "completed" || state == "checked"
  end

  def user
    project.user
  end
  

  def to_event
    event = Icalendar::Event.new
    event.start = self.created_at.strftime("%Y%m%dT%H%M%S")
    event.start = self.scheduled_to.strftime("%Y%m%dT%H%M%S") unless self.scheduled_to.nil?
    event.end = self.due_to.strftime("%Y%m%dT%H%M%S") unless self.due_to.nil?
    event.summary = self.name
    # event.description = self.description
    # event.location = 'Here !'
    event.klass = "PRIVATE"
    event.created = self.created_at
    event.last_modified = self.updated_at
    event.uid = self.id
    # event.url = task_url(self)
    return event
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
