class User < ActiveRecord::Base
  attr_accessible :login, :email, :password, :password_confirmation
  attr_reader :projects, :archived_projects, :tasks

  has_many :projects
  has_many :archived_projects, :class_name => 'Project::Archive'
  has_many :tasks, :through => :projects

  acts_as_authentic
  acts_as_tagger


  def active?
    active
  end

  def activate!
    self.active = true
    save
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
end
