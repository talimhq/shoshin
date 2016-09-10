# SHOSHIN - _Plateforme pédagogique_ 

## Liens utiles
* Pour discuter d'améliorations possibles ou pour signaler un bug, [ouvrez un
  ticket](www.github.com/idabmat/shoshin/issues).
* Pour des guides ou des tutoriels d'utilisation, rendez-vous sur notre
  [wiki](www.github.com/idabmat/shoshin/wiki).

## Informations techniques

### Dépendances
* Ruby _2.3.1_
* Rails _5.0.0.1_
* Base de donnéee: postgresql
* Redis pour les background jobs
* [mailcatcher](www.github.com/sj26/mailcatcher) pour ouvrir les emails en développement.

### Développement local
1. Copiez ce repo: `git clone https://github.com/idabmat/shoshin.git && cd
   shoshin`
2. Installez les gems: `bundle install`
3. Créez un fichier `config/database.yml` avec la configuration pour accéder à
   votre base de donnée locale.
4. Créez la base de donnée: `rails db:create && rails db:migrate && rails db:seed`
5. Lancez les background jobs: `bundle exec sidekiq`
6. Lancez le serveur: `rails s`
7. Ouvrez in navigateur et naviguez à l'addresse [localhost:3000](localhost:3000)

### Tests
`./bin/spring rspec`

### Contribuer
1. Faire une "Fork"
2. Créez une branche pour votre contribution (`git checkout -b ma-nouvelle-contribution)`
3. Faites vos modifications
4. Enregistrez vos modifications (`git add -A` puis `git commit -am 'Fonctionnalité ajoutée'`)
5. Envoyez votre contribution sur une nouvelle branche (`git push origin ma-nouvelle-contribution`)
6. Créez une "Pull Request"
