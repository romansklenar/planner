class Task < ActiveRecord::Base
  #attr_accessible :name, :description, :note, :completed_at, :checked_at, :due_to,
  #  :scheduled_to, :project, :tasklist, :worktype, :completed, :checked, :delegated_user
  
  belongs_to :project
  belongs_to :tasklist
  has_one    :user, :through => :tasklist
  belongs_to :delegated_user, :class_name => "User"
  belongs_to :worktype



  default_scope :order => 'position ASC'
  named_scope :incomplete, :conditions => { :completed => false }
  named_scope :completed, :conditions => { :completed => true }
  named_scope :recently_completed, :conditions => { :completed => true }, :order => 'completed_at DESC', :limit => 15

  validates_presence_of :name
  validates_presence_of :project,  :if => Proc.new { |tasklist| tasklist.tasklist.blank? }, :message => "Task {{value}} must be part of some tasklist or project"
  validates_presence_of :tasklist, :if => Proc.new { |tasklist| tasklist.project.blank? }, :message => "Task {{value}} must be part of some tasklist or project"


  acts_as_list :scope => :project
  acts_as_taggable
  acts_as_state_machine :initial => :active


  state :active, :enter => Proc.new { |task|
    task.completed_at = task.checked_at = nil
    task.completed = task.checked = false
  }
  state :completed, :enter => Proc.new { |task|
    task.completed_at = Time.zone.now
    task.completed = true
  }
  state :checked, :enter => Proc.new { |task|
    task.checked_at = Time.zone.now
    task.checked = true
    task.bug.close! unless task.bug.nil?
  }


  event :activate do
    transitions :to => :active, :from => [:completed]
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

  def toggle_completed!
    completed? ? activate! : complete!
    completed?
  end

  def toggle_checked!
    checked? ? activate! : checked?
    checked?
  end

  def delegated?
    delegated_user.nil? == false
  end



  def after_save
    deliver_task_assigned_information! if self.changed.include?('delegated_user_id')
  end


  def self.create_from_bug(bug)
    raise ArgumentError, "Cannot generate task, resolver of bug was not defined" if bug.proposed_user.nil? && bug.actual_user.nil?
    bug.actual_user = bug.proposed_user if bug.actual_user.nil?
    task = create(
        :name => bug.name,
        :description => bug.description,
        :note => bug.note,
        :worktype => Worktype.bugfix,
        :delegated_user => bug.actual_user,
        :tasklist => bug.actual_user.inbox_list
    )
    bug.task = task
    bug.save
    task
  end


  def to_ical_event
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
    event
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end


  private

  def deliver_task_assigned_information!
    Notifier.task_assigned_information(self, self.delegated_user)
  end

end
