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
      h2("Mode d'emploi")
    ),
    
    # Contenu lié à l'onglet "Simulation"
    tabItem(
      tabName = "simu",
      h2("Partie simulation"),
      fluidRow(
        box(width = 12),
        box(width = 12)
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