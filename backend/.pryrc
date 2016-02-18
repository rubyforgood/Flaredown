Pry.config.pager = false

Pry.config.color = true

Pry.config.history.should_save = true

if defined?(Rails)
  Pry.config.prompt_name = "#{Rails.application.class.parent_name.downcase.green}/#{Rails.env.red}"
end
