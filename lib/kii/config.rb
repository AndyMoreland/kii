module Kii
  CONFIG = YAML.load_file("#{Rails.root}/config/kii.yml")
  CONFIG.symbolize_keys!
end