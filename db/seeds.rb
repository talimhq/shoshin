# Create cycles and levels
cycle2 = Cycle.create!(
  name: 'Cycle 2',
  levels_attributes: [
    { name: 'CP', short_name: 'CP', level_type: 'Primaire' },
    { name: 'CE1', short_name: 'CE1', level_type: 'Primaire' },
    { name: 'CE2', short_name: 'CE2', level_type: 'Primaire' }
  ]
)
cycle3 = Cycle.create!(
  name: 'Cycle 3',
  levels_attributes: [
    { name: 'CM1', short_name: 'CM1', level_type: 'Primaire' },
    { name: 'CM2', short_name: 'CM2', level_type: 'Primaire' },
    { name: 'Sixième', short_name: '6e', level_type: 'Collège' }
  ]
)
cycle4 = Cycle.create!(
  name: 'Cycle 4',
  levels_attributes: [
    { name: 'Cinquième', short_name: '5e', level_type: 'Collège' },
    { name: 'Quatrième', short_name: '4e', level_type: 'Collège' },
    { name: 'Troisième', short_name: '3e', level_type: 'Collège' }
  ]
)
cycleL = Cycle.create!(
  name: 'Lycée',
  levels_attributes: [
    { name: 'Seconde', short_name: '2de', level_type: 'Lycée' },
    { name: 'Première ES', short_name: '1ES', level_type: 'Lycée' },
    { name: 'Première L', short_name: '1L', level_type: 'Lycée' },
    { name: 'Première S', short_name: '1S', level_type: 'Lycée' },
    { name: 'Terminale ES', short_name: 'TES', level_type: 'Lycée' },
    { name: 'Terminale L', short_name: 'TL', level_type: 'Lycée' },
    { name: 'Terminale S', short_name: 'TS', level_type: 'Lycée' }
  ]
)

# Create teachings
Teaching.create!(name: 'Français', short_name: 'Français', cycles: [cycle2, cycle3, cycle4, cycleL])
Teaching.create!(name: 'Langues vivantes', short_name: 'LV', cycles: [cycle2, cycle3, cycle4])
Teaching.create!(name: 'Enseignements artistiques', short_name: 'Ens Art', cycles: [cycle2, cycle3])
Teaching.create!(name: 'Éducation physique et sportive', short_name: 'EPS', cycles: [cycle2, cycle3, cycle4, cycleL])
Teaching.create!(name: 'Enseignement moral et civique', short_name: 'EMC', cycles: [cycle2, cycle3, cycle4, cycleL])
Teaching.create!(name: 'Questionner le monde', short_name: 'Quest Monde', cycles: [cycle2])
Teaching.create!(name: 'Mathématiques', short_name: 'Maths', cycles: [cycle2, cycle3, cycle4, cycleL])

Teaching.create!(name: 'Histoire et géographie', short_name: 'H-G', cycles: [cycle3, cycle4, cycleL])
Teaching.create!(name: 'Sciences et technologie', short_name: 'Sc et Tec', cycles: [cycle3])

Teaching.create!(name: 'Arts plastiques', short_name: 'Arts plastiques', cycles: [cycle4])
Teaching.create!(name: 'Éducation musicale', short_name: 'Musique', cycles: [cycle4])
Teaching.create!(name: 'Histoire des arts', short_name: 'HDA', cycles: [cycle4])
Teaching.create!(name: 'Physique-chimie', short_name: 'PC', cycles: [cycle4])
Teaching.create!(name: 'Sciences de la Vie et de la Terre', short_name: 'SVT', cycles: [cycle4])
Teaching.create!(name: 'Technologie', short_name: 'Techno', cycles: [cycle4])
Teaching.create!(name: 'Éducation aux médias et à l\'information', short_name: 'medias', cycles: [cycle4])

# Create core components
CoreComponent.create!(name: "Langue française à l’oral et à l’écrit")
CoreComponent.create!(name: "Langues étrangères et régionales")
CoreComponent.create!(name: "Langages mathématiques, scientifiques et informatiques")
CoreComponent.create!(name: "Langages des arts et du corps")
CoreComponent.create!(name: "Méthodes et outils pour apprendre")
CoreComponent.create!(name: "Formation de la personne et du citoyen")
CoreComponent.create!(name: "Systèmes naturels et systèmes techniques")
CoreComponent.create!(name: "Représentations du monde et activité humaine")
