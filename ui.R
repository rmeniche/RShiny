# header

header <- dashboardHeader(title = "Simulateur garde partagée")


sidebar <- dashboardSidebar(
  h3("Informations sur la Famille 1"),
  numericInput("revenu_f1", "Revenu mensuel (€) :", value = 3000, min = 0),
  sliderInput("heures_f1", "Heures/semaine pour la Famille 1 :", min = 0, max = 48, value = 25, step = 1),
  
  h3("Informations sur la Famille 2"),
  numericInput("revenu_f2", "Revenu mensuel (€) :", value = 2500, min = 0),
  sliderInput("heures_f2", "Heures/semaine pour la Famille 2 :", min = 0, max = 48, value = 20, step = 1),
  
  h3("Paramètres généraux"),
  numericInput("salaire_brut", "Salaire brut horaire (€) :", value = 12, min = 0),
  numericInput("transport_bonus", "Prime de transport (€) :", value = 50, min = 0),
  numericInput("vacation_weeks", "Nombre de semaines de vacances :", value = 5, min = 0, max = 52),
  
  actionButton("calculer", "Calculer")
  
)

#

body <- dashboardBody(
  h3("Résultats"),
  verbatimTextOutput("resultats"),
  
  h3("Visualisation"),
  plotOutput("graphique")
)


# 

ui <- dashboardPage(
  header,
  sidebar,
  body
)