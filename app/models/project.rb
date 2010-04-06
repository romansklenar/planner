class Project < ActiveRecord::Base
  attr_accessible :name, :user

  belongs_to :user
  has_many :tasks, :order => "position"
  
  acts_as_archive
  acts_as_taggable
  

  def self.restore(id)
    restore_all(["#{primary_key} = ?", id])
  end

  def to_calendar
    calendar = Icalendar::Calendar.new
    self.tasks.incomplete.each do |task|
      calendar.add task.to_event
    end
    return calendar
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
