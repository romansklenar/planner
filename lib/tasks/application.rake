desc "Setup all for app"
task :setup => ['db:migrate', 'load:users', 'load:projects', 'load:tasks']

namespace :load do
  desc "Load users into database"
  task :users do
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
  end

  desc "Load projects into database"
  task :projects do
    Project.delete_all
    users = User.all
    tags = ['@home, php', '@home, ruby', '@school, java']
    projects = ['Yardwork', 'Housework', 'Programming']
    
    projects.each do |name|
      user = users.rand
      project = Project.create!(:name => name, :user => user)
      user.tag(project, :with => tags.rand, :on => :tags)
    end
  end
  
  desc "Load tasks into database"
  task :tasks do
    Task.delete_all
    projects = Project.all
    words = File.readlines("./lib/tasks/words").sort_by { rand }
    35.times do
      Task.create!(:name => words.pop.titleize.strip, :project => projects.rand)
    end
  end
end
