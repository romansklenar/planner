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
  end

  desc "Load projects into database"
  task :projects do
    Project.delete_all
    users = User.all
    ['Yardwork', 'Housework', 'Programming'].each do |name|
      Project.create!(:name => name, :user => users.rand)
    end
  end
  
  desc "Load tasks into database"
  task :tasks do
    Task.delete_all
    projects = Project.all
    words = File.readlines("./lib/tasks/words").sort_by { rand }
    35.times do
      Task.create!(:name => words.pop.titleize, :project => projects.rand)
    end
  end
end
