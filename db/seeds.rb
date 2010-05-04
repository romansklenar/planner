# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

desc "Load users into database"

User.delete_all
logins = ['admin', 'user']
logins.each do |name|
  usr = User.new
  usr.login = name
  usr.email = "#{name}@example.com"
  usr.password = usr.password_confirmation = "demo"
  usr.save
  usr.activate!
end



desc "Load projects into database"

Project.delete_all
users = User.all
tags = ['@home, php', '@home, ruby', '@school, java', 'rails', 'link', 'read']
projects = ['Yardwork', 'Housework', 'Programming']

projects.each do |name|
  project = Project.create(:name => name, :user => users.rand)
  project.user.tag(project, :with => tags.rand, :on => :tags) if rand*10 > 4
end



desc "Load tasks into database"

Task.delete_all
users = User.all
projects = Project.all
words = File.readlines("./lib/tasks/words").sort_by { rand }
35.times do
  project = projects.rand
  tasklist = project.user.tasklists.rand
  task = Task.create(:name => words.pop.titleize.strip, :project => project, :tasklist => tasklist)
  task.complete! if rand*10 > 8
  task.user.tag(task, :with => tags.rand, :on => :tags) if rand*10 > 6
end



desc "Load bugs into database"

Bug.delete_all
users = User.all
bugs = ['Bug #1', 'Bug #2', 'Bug #3']
bugs.each do |name|
  Bug.create(:name => name, :reported_by => "John Doe", :proposed_worker => users.rand)
end
