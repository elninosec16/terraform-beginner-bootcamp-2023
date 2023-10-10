# Terraform Beginner Bootcamp 2023

## Week 2 Project Diagram 

![Week 2 Project Diagram](/pics/Week1.png)

## Week 2 - Table of Contents

3. Configure GitPod to install `Sinatra` for Ruby:
 #[Sinratra in Ruby Web Applications Server](https://sinatrarb.com/)

### Sinatra

Sinatra is a free and open source software web application library and domain-specific language written in Ruby.

[Sinatra](https://sinatrarb.com/)

### Running the Sinatra Web Server

```rb
bundle install
bundle exec ruby server.rb
```
> All the code for the Sinatra Web Server is setup on the `server.rb` file.


### Bundler
 
 It a Ruby package manager 
 
#### Install Gems
 
 ```rb
# frozen_string_literal: true

source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
 ```  
 
 To install the package on the `Gemsfile` you need to run `bundle install` command
 
 The `GemsFile.lock` will be installed after the packages installation to lock down the Gems version being used.
 
#### Execute `Ruby` scripts
 
The `bundle exec` is used to run future `Ruby` scripts.
 
#### `Ruby` ActiveModel

[Active Model Basics](https://guides.rubyonrails.org/active_model_basics.html)

#### `Ruby` Active Record Validations

[Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html)

#### Bearer Authentication Token

It's also called `Token Authentication`

[Bearer Authentication](https://swagger.io/docs/specification/authentication/bearer-authentication/)
 