class Task < ActiveRecord::Base
  attr_accessible :name, :complete, :project
  
  belongs_to :project

  def self.find_incomplete(options = {})
    with_scope :find => options do
      find_all_by_complete(false, :order => 'created_at DESC')
    end
  end

  def to_event
    event = Icalendar::Event.new
    # event.start = self.date.strftime("%Y%m%dT%H%M%S")
    # event.end = self.due_to.strftime("%Y%m%dT%H%M%S")
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
end
