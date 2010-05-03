class Project < ActiveRecord::Base
  attr_accessible :name, :user

  belongs_to :user
  has_many :tasks, :order => "position"
  
  acts_as_state_machine
  acts_as_taggable
  
  def archive
    # todo: implement
  end

  def self.restore(id)
    # todo: implement
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
