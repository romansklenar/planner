class Tasklist < ActiveRecord::Base
  default_scope :conditions => [ 'kind IN (?)', ['I','N','S'] ]

  belongs_to :user
  has_many :tasks, :order => "position"


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
