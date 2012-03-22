class Core < Sinatra::Base
  GITHUB = YAML.load_file(File.join(settings.root, 'config/github_key.yml'))
  Mongoid.load!(File.join(settings.root, 'config/mongoid.yml'))

  set :public_folder, Proc.new { File.join(root, "static") }  
  set :views, settings.root + '/app/views'
  set :slim, :pretty => true
  
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :github, GITHUB['id'], GITHUB['secret'] 
  end
  
  helpers do
    def gravatar email
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}" if email
    end
  end
  
  get '/' do
    slim :home
  end
  
  get '/auth/failure' do
    "Not cool, bro"
  end
  
  get '/auth/github/callback' do
    Hacker.find_or_create_by uid: request.env['omniauth.auth']['uid'],
                             name: request.env['omniauth.auth']['info']['nickname'],
                             email: request.env['omniauth.auth']['info']['email']
    redirect '/'
  end

end