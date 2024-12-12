# Header

header <- dashboardHeader(title = "Simulateur de garde partagée")

# Sidebar

sidebar <- dashboardSidebar(
  sidebarMenu( # Liste des onglets
    menuItem("Mode d'emploi", tabName = "manuel", icon = icon("book-open")),
    menuItem("Simulateur", tabName = "simu", icon = icon("calculator")),
    menuItem("Résumé", tabName = "resume", icon = icon("table-list"))
  )
)

# Body

body <- dashboardBody(
  tabItems(
    
    # Contenu lié à l'onglet "Mode d'emploi"
    tabItem(
      tabName = "manuel",
      h2("Mode d'emploi"),
      fluidRow(
        box(
          width = 12,
          h3("Hypothèses prises en compte"),
          infoBox("Charges sociales salariales", "23% du brut", icon = icon("credit-card"), fill = TRUE),
          infoBox("Charges sociales patronales", "41.7% du brut", icon = icon("credit-card"), fill = TRUE),
          infoBox("Nombre d'heures semaine maximum", "48", icon = icon("credit-card"), fill = TRUE)
        )
      )
    ),
    
    # Contenu lié à l'onglet "Simulation"
    tabItem(
      tabName = "simu",
      h2("Partie simulation"),
      fluidRow(
        box(
          width = 4,
          h3("Informations sur la Famille 1"),
          numericInput("revenu_f1", "Revenu mensuel (€) :", value = 3000, min = 0),
          sliderInput("heures_f1", "Heures/semaine pour la Famille 1 :", min = 0, max = 48, value = 25, step = 1)
        ),
        box(
          width = 4,
          h3("Informations sur la Famille 2"),
          numericInput("revenu_f2", "Revenu mensuel (€) :", value = 2500, min = 0),
          sliderInput("heures_f2", "Heures/semaine pour la Famille 2 :", min = 0, max = 48, value = 20, step = 1)
        ),
        box(
          width = 4,
          h3("Paramètres généraux"),
          numericInput("salaire_brut", "Salaire brut horaire (€) :", value = 12, min = 0),
          numericInput("transport_bonus", "Prime de transport (€) :", value = 50, min = 0),
          numericInput("vacation_weeks", "Nombre de semaines de vacances :", value = 5, min = 0, max = 52),
          h3("Calcul par durée"),
          selectInput("duree_type", "Type de durée :", choices = c("jour", "mois"), selected = "mois"),
          numericInput("duree_nb", "Nombre de jours ou mois :", value = 1, min = 1)
        )
      ),
      actionButton("calculer", "Calculer"),
      
      fluidRow(
        align="center",
        box(
          h3("Résultats"),
          verbatimTextOutput("resultats")
          ),
        box(
          h3("Visualisation"),
          plotOutput("graphique") 
        )
      )
    ),
    
    # Contenu lié à l'onglet "Résumé"
    tabItem(
      tabName = "resume",
      h2("Partie résumé"),
      fluidRow(
        box(width = 12),
        box(width = 12)
      )
    )
  ),
  
  # Pied de page
  includeHTML("www/footer.html")
)


# Create the UI object

ui <- dashboardPage(
  header,
  sidebar,
  body
)