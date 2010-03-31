class User < ActiveRecord::Base
  acts_as_authentic

  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
end
