# application seed file

desc "Load users into database"

User.delete_all
admin = User.new
admin.login = "admin"
admin.email = "admin@example.com"
admin.password = admin.password_confirmation = "demo"
admin.save
admin.activate!

usr = User.new
usr.login = "user"
usr.email = "user@example.com"
usr.password = usr.password_confirmation = "demo"
usr.save
usr.activate!



desc "Load projects into database"

Project.delete_all
users = User.all
tags = ['@home, php', '@home, ruby', '@school, java', 'rails', 'link', 'read']
projects = ['Yardwork', 'Housework', 'Programming']

projects.each do |name|
  user = users.rand
  project = Project.create!(:name => name, :user => user)
  user.tag(project, :with => tags.rand, :on => :tags)
end



desc "Load tasks into database"

Task.delete_all
projects = Project.all
words = File.readlines("./lib/tasks/words").sort_by { rand }
35.times do
  task = Task.create!(:name => words.pop.titleize.strip, :project => projects.rand)
  task.user.tag(task, :with => tags.rand, :on => :tags) if rand*10 > 6
end
