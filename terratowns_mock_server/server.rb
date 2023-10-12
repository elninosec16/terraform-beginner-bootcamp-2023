require 'sinatra'
require 'json'
require 'pry'
require 'active_model'

# In Ruby, when starts with $ = 'global variable'
$home = {}

# ruby class that includes validations for ActiveRecords
class Home
  # ActiveModel is part of Ruby on Rails.
  include ActiveModel::Validations

  # Create sine virtual attributes to stored on this object
  # This will set a gretter and setter
  # eg.
  # home= new Home()
  # home.town = 'hello ' # setter
  # home.town() # getter
  attr_accessor :town, :name, :description, :domain_name, :content_version
  
  # gamer-grotto
  validates :town, presence: true, inclusion: { in: [
    'melomaniac-mansion',
    'cooker-cove',
    'video-valley',
    'the-nomad-pad',
    'gamers-grotto'
  ] }
  # visibales to all users
  validates :name, presence: true
  validates :description, presence: true
  # lock down to only from CloudFront
  validates :domain_name, 
    format: { with: /\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
    # uniqueness: true, 
  
  # contect_version = integer
  validates :content_version, numericality: { only_integer: true }
end

# The bigining of the actual code
class TerraTownsMockServer < Sinatra::Base

  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end
  
  # Return a hardcode access_token
  def x_access_code
    return '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  def x_user_uuid
    return 'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    auth_header = request.env["HTTP_AUTHORIZATION"]
    # Check if the Authorization header exists?
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
    
    # Does the token match the one in the variable/db file?
    # code = access_code = token
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # Was there a user_uuid in the body payload json?
    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # The code and the user_uuid should be matching for this user
    # in rails: user.find_by access_code: code, user_uuid: user_uuid
    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end
  
  # The starts of the four actions [CREATE, READ, UPDATE, DELETE]
  # CREATE
  post '/api/u/:user_uuid/homes' do
    #Ruby functions '()'
    ensure_correct_headings
    find_user_by_bearer_token
    # puts will print to the terminal as print()
    puts "# create - POST /api/homes"

    # a begin/resource is a try/catch, if an error occurs, result it.
    begin
      # Manual parse as Sinatra does not do it automatically
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]
    town = payload["town"]
    
    # print to console to make easier to read
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"

    # create a new Home model & set the attributes
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    
    # Validate the validation pass
    unless home.valid?
      error 422, home.errors.messages.to_json
    end
    
    #Generate a random uuid
    uuid = SecureRandom.uuid
    puts "uuid #{uuid}"
    # Save the random uuid on mock db as global variable.
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }
    
    # return global variable.
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    # Updated to validate domain_name
    home = Home.new
    home.town = $home[:town]
    home.domain_name = $home[:domain_name]
    home.name = name
    home.description = description
    home.content_version = content_version

    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end
    
    # Delete home uuid from the mock db.
    uuid = $home[:uuid]
    $home = {}
    { uuid: uuid }.to_json
  end
end

# This is what running the server
TerraTownsMockServer.run!