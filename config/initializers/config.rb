Rails.application.configure do
  config.brands = %w(
    workarea
    sanrio
    freshfinds
    bouqs
    heineken
    woodcraft
    limecrime
    uniquephoto
    baudville
    bhldn
    harriet_carter
    paragon
    lonely_planet
    world_wide_stereo
    james_avery
    justcandy
  )

  config.social = OpenStruct.new({
    email:         'ges.jeremie@gmail.com',
    facebook:      'https://www.facebook.com/jeremie.ges',
    github:        'https://github.com/GesJeremie',
    medium:        'https://medium.com/@jeremieges',
    stackoverflow: 'https://stackoverflow.com/users/1538101/jeremie-ges'
  })

  config.stack = OpenStruct.new({
    application: %w(nginx ruby rails postgresql sidekiq javascript ember stimulus_js sass elixir phoenix workarea),
    business:    %w(jira trello hipchat slack invision intercom),
    devops:      %w(digital_ocean nanobox bamboo git github bitbucket),
    utilities:   %w(stripe paypal google_analytics mailgun sentry hotjar)
  })
end
