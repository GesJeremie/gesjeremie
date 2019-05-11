Rails.application.routes.draw do

  # Redirect www to no-www
  if Rails.env.production?
    constraints subdomain: 'www' do
      get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
    end
  end

  root 'pages#home'
end

