class Project < ActiveRecord::Base
  attr_accessible :name, :user

  belongs_to :user
  has_many :tasks
  
  acts_as_archive
  

  def self.restore(id)
    restore_all(["#{primary_key} = ?", id])
  end

  def to_calendar
    calendar = Icalendar::Calendar.new
    self.tasks.find_incomplete.each do |task|
      calendar.add task.to_event
    end
    return calendar
  end

end
