class Task < ActiveRecord::Base
  attr_accessible :name, :completed, :completed_at, :due_to, :scheduled_at, :project
  belongs_to :project
  acts_as_list :scope => :project
  acts_as_taggable

  default_scope :order => 'position ASC'
  named_scope :incomplete, :conditions => { :completed => false }
  named_scope :completed, :conditions => { :completed => true }
  named_scope :recently_completed, :order => 'completed_at DESC', :limit => 15

  validates_presence_of :name, :project



  def completed=(value)
    completed = value
    self.completed_at = completed ? Time.now.utc : nil
  end

  def completed?
    completed == true
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
