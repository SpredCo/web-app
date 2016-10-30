# spred-web
## Installation
1. Install ruby
  * From RVM
  
   First of all you need to install [RVM](https://rvm.io/).
   Once it's done install ruby (version is precised in [.ruby-version](https://github.com/SpredCo/web-app/blob/master/.ruby-version)) by typing
   ```bash
   rvm install ruby-2.3.1
   ```
   Then leave and re-enter your project directory.
   ```bash
   cd ..; cd web-app
   ```
  * From Rbenv
  
   First of all you need to install [Rbenv](https://github.com/rbenv/rbenv)
   Once it's done install ruby (version is precised in [.ruby-version](https://github.com/SpredCo/web-app/blob/master/.ruby-version)) by typing
   ```bash
  rbenv install 2.3.1
   ```
   Then leave and re-enter your project directory.
   ```bash
   cd ..; cd web-app
   ```
2. Install dependencies
  * Install bundler
   ```bash
   gem install bundler
   ```
  * Install project dependencies
   ```bash
   bundle install
   ```
## Running
```bash
bundle exec ./start.sh
```
