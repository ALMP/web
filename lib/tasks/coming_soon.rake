# frozen_string_literal: true
namespace :coming_soon do
  desc "Turning on 'Coming Soon' page."
  task :on do
    `cp public/index.comingsoon.html public/index.html`
    puts 'Coming soon page enabled.'
  end

  desc 'Restore application based home page'
  task :off do
    `rm public/index.html`
    puts 'Coming soon page disabled.'
  end
end
