module Kii
  class Template
    attr_reader :path
    
    def initialize(template_name)
      @path = "#{Rails.root}/app/templates/#{Kii::CONFIG[:template]}"
      
      # Makes Rails look for views in app/templates/[template name]/views
      # instead of app/views.
      ActionController::Base.view_paths = ["#{@path}/views"]
      
      # Handling template helpers
      helper_files = Dir["#{@path}/helpers/*.rb"]
      if !helper_files.empty?
        # TODO: Reload on every request in development mode.
        helper_files.each {|h| require h }
      end
    end
    
    def run_template_init_file
      init_file = "#{@path}/init.rb"
      require init_file if File.file?(init_file)
    end
  end
end