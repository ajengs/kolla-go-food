# README
Ruby on Rails

* Ruby version : 5.1.4

* Install instructions
  * run command on terminal
  ```
  $ gem install rails
  ```
  * make directory with your project name, then go to that folder. Eg: 
  ```
  $ mkdir go-food
  $ cd go-food
  ```
  * To make rails project, run command 
  ```
  $ rails new
  ```
  * To start the server in development mode, run command 
  ```
  $ rails server
  ```
  or
  ```
  $ rails s
  ```
  If you are on Ubuntu 16.04, you might need to edit file ``Gemfile``, uncomment line 20 (use ``gem therubyracer``).

  Rails use default port 3000, so if the server is up, access ``http://localhost:3000`` from your browser.

* In rails you can run command with its shortened version, the first letter of the command ``rails s`` == ``rails server``, ``rails g`` == ``rails generate``

* REST (Representational State Transfer) is an architectural style for designing distributed systems. 
  Principles of REST
  * Resources expose easily understood directory structure URIs.
  * Representations transfer JSON or XML to represent data objects and attributes.
  * Messages use HTTP methods explicitly (for example, GET, POST, PUT, and DELETE).
  * Stateless interactions store no client context on the server between requests. State dependencies limit and restrict scalability. The client holds session state.

* HTTP methods
  * GET : retrieve information
  * POST : request that the resource at the URI do something with the provided entity.
  * PUT : store an entity at a URI.
  * PATCH : Update only the specified fields of an entity at a URI.
  * DELETE : Request that a resource be removed

* HTTP status codes
  Status codes indicate the result of the HTTP request.
  * 1XX - informational
  * 2XX - success (200: OK)
  * 3XX - redirection (301: page redirected)
  * 4XX - client error (401: not logged in, 403: forbidden, 404: not found)
  * 5XX - server error (500: internal error)

Source on REST: https://spring.io/understanding/REST

* Controller in Rails

  To make controller, run command ``rails generate controller <ControllerName> <action_name>.`` Eg:
  ```
  $ rails generate controller Home hello
  ```

  This command will generate some necessary files for new ``Home`` controller, and also modify ``config/routes.rb`` file for the new controller default route.

  If you already got git on you machine, you can check modified and new files created with ``git status``.

  Access ``http://localhost:3000/home/hello`` from your browser to view newly added controller (and view). Make sure the server is still up.

* Models in Rails
  To make new model, run command ``rails g model <model_name>``
  ```
  $ rails g model user
  ```
  This command will generate some necessary files for new ``User`` model, including file migration for that model in ``db/migrate``

* To make database for the first time in rails project:
  ```
  $ rails db:create
  ```
  This will make new file ``config/database.yml``

* Migration in rails
  Edit new file migration then run command ``rails db:migrate`` to run migration. Eg:
  ```
  class CreateUsers < ActiveRecord::Migration[5.1]
    def change
      create_table :users do |t|
        t.string :username, null: false
        t.string :full_name

        t.timestamps
      end
    end
  end
  ```
  then run ``rails db:migrate`` on terminal. If we want to rollback the last migration, use ``rails db:rollback``

* Rails has console interface that we can use for debugging purpose
  ```
  $ rails console
  ```
  or 
  ```
  $ rails c
  ```

* To launch server in production mode
  ```
  $ rails server -e production
  ```
  this needs some more configuration. Or you can user
  ```
  $ RAILS_NEW = production rails server
  ```

* Scaffold: generate model, view, and controller in the same time
  ```
  $ rails generate scaffold Food name:string description:text image_url:string price:decimal
  ```

  To rollback scaffold use ``$ rails destroy scaffold <controller name>``

* Use ``$ rails routes`` to show the complete generated routes

* `db/seeds.rb`. This file should contain all the record creation needed to seed the database with its default values.

  Examples:
  ```
  movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
  Character.create(name: 'Luke', movie: movies.first)
  ```

  Run ``$ rails db:seed``

* Validation and unit testing
  
  Modify file `Gemfile`
  ```
  group :development, :test do
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
    # Adds support for Capybara system testing and selenium driver
    # gem 'capybara', '~> 2.13'
    # gem 'selenium-webdriver'
    gem 'rspec-rails', '~> 3.6'
    gem 'factory_girl_rails', '~> 4.4.1'
  end

  group :test do
    gem 'faker', '~> 1.4.3'
    gem 'capybara'
    gem 'database_cleaner', '~> 1.3.0'
    gem 'launchy', '~> 2.4.2'
    gem 'selenium-webdriver', '~> 2.43.0'
  end
  ```

  Add these lines to class Application
  ```
  config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  ```

* To use gem FactoryGirl, make a directory under folder spec `factories/food.rb`

  Fill the file with the following lines
  ```
  FactoryGirl.define do
    factory :food do
      name 'Nasi Uduk'
      description 'Betawi style steamed rice cooked in coconut milk'
      price 10000.0
    end
  end
  ```

  You can use FactoryGirl in your spec file to build new object to test. E.g:
  ```
  ~
  it 'has a valid factory' do
    expect(FactoryGirl.build(:food)).to be_valid
  end
  ~
  ```

* You can also override the syntax, so you don't have to type FactoryGirl everytime you build.

  In file `spec/rails_helper.rb`, add the following line
  ```
  config.include FactoryGirl::Syntax::Methods
  ```

  Then you can modify your spec file to 
  ```
  ~
  it 'has a valid factory' do
    expect(build(:food)).to be_valid
  end
  ~
  ```

* Gem Faker. Modify `Gemfile` in group test
  ```
  gem 'faker', git: 'https://github.com/stympy/faker.git'
  ```

  then run ``$ bundle install`` again

* Use Faker. You can assign Faker to your class attributes
  ```
  FactoryGirl.define do
    factory :food do
      name { Faker::Food.dish }
      description 'Betawi style steamed rice cooked in coconut milk'
      price 10000.0
    end
  end
  ```

* Specs for controller. At `Gemfile` add following line in group :development, :test
  ```
  gem 'rails-controller-testing'
  ```
  Don't forrget to bundle install

* Make new directory and file under folder spec `spec/controllers/foods_controller_spec.rb`

* Category feature
  * Make new spec for category model manually. Watch it fails.
  * Make new model for category manually. Add factory.
  ``$ rails g migration CreateCategory name:string``
  * Run ``$ rails db:migrate``
  * Add spec for category in food_spec.rb. Expect it to be valid when food has category. Watch it fails.
  * Add `belongs_to :category, optional: true` in food.rb. Run in command
  ```
  $ rails g migration add_category_to_foods category:belongs_to
  ```
  Run ``$ rails db:migrate``
  Run food_spec again. It should succeed.

  * Add spec to category, it can't be destroyed while food is using it. Watch it fails.
  * Add :ensure_not_referenced_by_any_food method in category model. 