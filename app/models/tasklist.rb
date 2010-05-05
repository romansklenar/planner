class Tasklist < ActiveRecord::Base
  default_scope :conditions => [ 'kind IN (?)', ['I','N','S'] ]

  belongs_to :user
  has_many   :tasks, :order => "position"
  belongs_to :grant


  validates_presence_of :name, :kind, :user
  validates_inclusion_of :kind, :in => %w(I N S P), :message => "{{value}} is not a valid tasklist type"


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
