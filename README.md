tomtom_webfleet_connect
=======================

Ruby gem for easily integrate tomtom webfleet connect

#Content

- gestion retour http (200, ...)
- interpretation des code retour d'erreur tomtom
- gestion paramétrage
- gestion des appel
- parssage du csv
- gestion multi environnement
- gestion requête par paire (pour prise en charge et dépose)
- formatage divers (lat, lng, date...)
- Gestion des dépassements de quota tomtom


#Install

##Add gem to gemfile :
```
gem 'tomtom_webfleet_connect', git: 'https://github.com/Ecotaco/tomtom_webfleet_connect_gem.git'
```

##Add model to your app database :
```
rails generate tomtom_webfleet_connect
rake db:migrate
```

#Configure

##Add users :
```
TomtomWebfleetConnect::Models::User.create(name: "name", password: "password")
```

##Add methods :
```
TomtomWebfleetConnect::Models::TomtomMethod.create name: "insertDriverExtern", quota:10, quota_delay: 1
```

##On test :
For rspec you need to create a local_env.yml in config directory to set environnement variable like this :
```
ACCOUNT: 'xxx'
API_KEY: 'xxx'
LANG: 'fr'
FORMAT: 'json'
USER_NAME: 'xxx'
USER_PASSWORD: 'xxx'
USER2_NAME: 'xxx'
USER2_PASSWORD: 'xxx'
```

