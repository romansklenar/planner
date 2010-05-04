class User < ActiveRecord::Base
  attr_accessible :login, :email, :password, :password_confirmation
  attr_reader :projects, :archived_projects, :tasks

  has_many :projects,
           :order => 'tasklists.created_at ASC',
           :conditions => [ 'state = ?', 'active' ]

  has_many :archived_projects,
           :class_name => 'Project',
           :order => 'tasklists.created_at ASC',
           :conditions => [ 'state = ?', 'archived' ]

  has_many :tasklists

  has_one  :inbox_list,
           :class_name => 'Tasklist',
           :conditions => [ 'kind = ?', 'I' ]

  has_one  :next_actions_list,
           :class_name => 'Tasklist',
           :conditions => [ 'kind = ?', 'N' ]

  has_one  :someday_list,
           :class_name => 'Tasklist',
           :conditions => [ 'kind = ?', 'S' ]

  has_many :tasks,
            :through => :tasklists,
            :conditions => [ 'kind IN (?)', ['I','N','S', 'P'] ]


  acts_as_authentic
  acts_as_tagger


  def active?
    active
  end

  def activate!
    self.active = true
    save
  end

  def tag_counts
    Tag.find :all,
      :select => 'tags.*, COUNT(*) AS count',
      :joins => [
        "JOIN taggings ON tags.id = taggings.tag_id AND taggings.context = 'tags'",
        "JOIN users ON taggings.tagger_id = users.id AND users.id = #{self.id}"
      ],
      :group => "tags.id, tags.name",
      :having => "COUNT(*) > 0"
  end


  def after_create
    create_inbox_list
    create_next_actions_list
    create_someday_list
  end

  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end


  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end


  private

  def create_inbox_list
    Tasklist.create(:name => "Inbox", :kind => "I", :user => self)
  end

  def create_next_actions_list
    Tasklist.create(:name => "Next Actions", :kind => "N", :user => self)
  end

  def create_someday_list
    Tasklist.create(:name => "Someday", :kind => "S", :user => self)
  end
end
