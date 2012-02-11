# http://groups.google.com/group/rubyonrails-talk/browse_thread/thread/d5ee38d84660e93c
# Ralph: http://guides.rubyonrails.org/asset_pipeline.html is wrong
Rails.application.config.assets.paths << (Rails.root.join("app", "assets", "flash")).to_s