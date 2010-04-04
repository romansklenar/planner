class Project < ActiveRecord::Base
  has_many :tasks

  def to_calendar
    calendar = Icalendar::Calendar.new
    self.tasks.find_incomplete.each do |task|
      calendar.add task.to_event
    end
    return calendar
  end

end
