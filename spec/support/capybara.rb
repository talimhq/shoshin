Capybara.default_driver = :webkit
Capybara.javascript_driver = :webkit
Capybara::Webkit.configure do |config|
  config.allow_url('cdn.mathjax.org')
end
