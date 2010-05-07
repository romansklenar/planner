class Project < Tasklist
  default_scope :conditions => [ 'kind = ?', 'P' ]

  belongs_to :user
  has_many   :tasks, :order => "position"

  # Returns work types for Rails form select helper
  def self.find_for_select
    self.all.collect { |w| [ w.name, w.id ] }
  end

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
end
