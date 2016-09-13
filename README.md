[![Code Climate](https://codeclimate.com/github/TalimSolutions/shoshin/badges/gpa.svg)](https://codeclimate.com/github/TalimSolutions/shoshin)
[![Test Coverage](https://codeclimate.com/github/TalimSolutions/shoshin/badges/coverage.svg)](https://codeclimate.com/github/TalimSolutions/shoshin/coverage)
[![Build Status](https://travis-ci.org/TalimSolutions/shoshin.svg?branch=master)](https://travis-ci.org/TalimSolutions/shoshin)
# SHOSHIN - _Plateforme pédagogique_ 

[![Join the chat at https://gitter.im/shoshin-academy/Lobby](https://badges.gitter.im/shoshin-academy/Lobby.svg)](https://gitter.im/shoshin-academy/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Liens utiles
* Pour discuter d'améliorations possibles ou pour signaler un bug, [ouvrez un
  ticket](https://www.github.com/TalimSolutions/shoshin/issues).
* Pour des guides ou des tutoriels d'utilisation, rendez-vous sur notre
  [wiki](https://www.github.com/TalimSolutions/shoshin/wiki).

## Informations techniques

### Dépendances
* Ruby _2.3.1_
* Rails _5.0.0.1_
* Base de donnéee: postgresql
* Redis pour les background jobs
* [mailcatcher](https://www.github.com/sj26/mailcatcher) pour ouvrir les emails en développement.

### Développement local
1. Copiez ce repo: `git clone https://github.com/TalimSolutions/shoshin.git && cd
   shoshin`
2. Installez les gems: `bundle install`
3. Créez un fichier `config/database.yml` avec la configuration pour accéder à
   votre base de donnée locale.
4. Créez la base de donnée: `rails db:create && rails db:migrate && rails db:seed`
5. Lancez les background jobs: `bundle exec sidekiq`
6. Lancez le serveur: `rails s`
7. Ouvrez in navigateur et naviguez à l'addresse [localhost:3000](http://localhost:3000)

### Tests
1. `rails db:test:prepare`
2. `./bin/spring rspec`

### Contribuer
1. Faire une "Fork"
2. Créez une branche pour votre contribution (`git checkout -b ma-nouvelle-contribution)`
3. Faites vos modifications
4. Enregistrez vos modifications (`git add -A` puis `git commit -am 'Fonctionnalité ajoutée'`)
5. Envoyez votre contribution sur une nouvelle branche (`git push origin ma-nouvelle-contribution`)
6. Créez une "Pull Request"

### LICENCE
Copyright &copy; Ta'lim - soluções inteligentes - LTDA ME

Shoshin est un logiciel libre disponibilisé sous les termes de la licence APGLv3. Voir la [LICENCE](https://github.com/TalimSolutions/shoshin/blob/master/LICENSE).
