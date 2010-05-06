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
projects = ['Painting', 'Yardwork', 'Housework', 'Programming']

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
  task = Task.create
  task.name = words.pop.titleize.strip
  task.project = projects.rand
  task.tasklist = task.project.user.tasklists.rand
  task.due_to = (rand*10).to_i.days.ago.to_date if rand*10 > 6
  task.scheduled_to = (rand*10).to_i.days.ago.to_date if rand*10 > 6
  #toggle_completed! if rand*10 > 8
  task.save
  task.user.tag(task, :with => tags.rand, :on => :tags) if rand*10 > 6
end



desc "Load bugs into database"

Bug.delete_all
users = User.all
bugs = ['Bug #1', 'Bug #2', 'Bug #3']
bugs.each do |name|
  Bug.create(:name => name, :reported_by => "John Doe", :proposed_user => users.rand)
end



desc "Load work types into database"

Worktype.delete_all
tasks = Task.all
works = {'bugfix' => 200.00, 'implementation' => 150.00, 'documentation' => 100.00}
works.each do |name, price|
  work = Worktype.create(:name => name, :price_per_hour => price)
  tasks.rand.worktype = work
end



desc "Load grants into database"

tasklists = Tasklist.all
grants = {'CESNET' => 25000.00, 'Virtlab' => 15000.00, 'kat454' => 10000.00, 'CPIT' => 5000.00}
grants.each do |name, budget|
  grant = Grant.find_or_create_by_name(name, :budget => budget)
  tasklists.rand.grant = grant
end
