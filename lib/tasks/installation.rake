namespace :kii do
  desc "Performs the operations Kii needs to run."
  task :install => [:pre_install, :environment] do
    say "Migrating the database"
    Rake::Task["db:migrate"].invoke
    
    if Page.find_by_permalink(Kii::CONFIG[:home_page])
      say "Kii is already installed!"
      exit
    end
    
    say "Creating home page"
    Page.create!(:title => Kii::CONFIG[:home_page].titleize, :revision_attributes => {:body => File.read("#{Rails.root}/lib/kii/default_homepage")})
  end
  
  task :pre_install do
    require 'fileutils'
    
    say "Creating database.yml"
    rails_root = File.expand_path("#{File.dirname(__FILE__)}../../../")
    FileUtils.cp("#{rails_root}/config/database.sample.yml", "#{rails_root}/config/database.yml")
  end
  
  def say(this)
    puts ">> #{this}"
  end
end