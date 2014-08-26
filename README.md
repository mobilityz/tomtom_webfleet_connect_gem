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
gem 'tomtom_webfleet_connect', git: 'https://github.com/maxime-lenne/tomtom_webfleet_connect.git'
```

##Add model to your app database :
```
rails generate tomtom_webfleet_connect
rake db:migrate
```

#Configure

##Add users :
```
TomtomWebfleetConnect::Models::User.create(name: "api", password: "ecotaco")
```

##Add methods :
```
TomtomWebfleetConnect::Models::TomtomMethod.create name: "insertDriverExtern", quota:10, quota_delay: 1
```
