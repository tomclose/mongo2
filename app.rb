require 'sinatra'
require 'mongoid'
require 'json'

Mongoid.load!("mongoid.yml", :development)

class ShortURL
    include Mongoid::Document
    field :token
    field :full_url
end

get '/' do 
    erb :form
end

post '/' do 
    url = params[:url]
    token = params[:token]
    return erb :form unless url && token

    # check to see if the token is already taken
    if ShortURL.where(:token => token).exists?
        # That token is already taken
        erb :error_form
    else
        ShortURL.create!(:full_url => url, :token => token)
        erb :success
    end

end

get '/:token' do
    t = ShortURL.find_by(:token => params[:token])
    if t
        redirect_to t.full_url
    else
        erb :incorrect_url
    end
end