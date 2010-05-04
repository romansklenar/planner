class Notifier < ActionMailer::Base
  default_url_options[:host] = "example.com"

  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "ToDo Notifier <noreply@example.com>"
    recipients    user.email
    sent_on       Time.zone.now
    body          :password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "ToDo Notifier <noreply@example.com>"
    recipients    user.email
    sent_on       Time.zone.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Activation Completed"
    from          "ToDo Notifier <noreply@example.com>"
    recipients    user.email
    sent_on       Time.zone.now
    body          :root_url => root_url
  end

  def task_assigned_information(user, task)
    subject       "New task was assigned"
    from          "ToDo Notifier <noreply@example.com>"
    recipients    user.email
    sent_on       Time.zone.now
    body          :task => task, :user => user
  end
end