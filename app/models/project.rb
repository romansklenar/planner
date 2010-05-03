class Project < ActiveRecord::Base
  attr_accessible :name, :user

  belongs_to :user
  has_many :tasks, :order => "position"

  acts_as_taggable

  acts_as_state_machine :initial => :active

  state :active
  state :archived

  event :activate do
    transitions :to => :active, :from => [:archived]
  end

  event :archivate do
    transitions :to => :archived, :from => [:active]
  end

  def to_calendar
    calendar = Icalendar::Calendar.new
    self.tasks.incomplete.each do |task|
      calendar.add task.to_ical_event
    end
    return calendar
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
