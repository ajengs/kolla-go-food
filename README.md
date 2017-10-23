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
