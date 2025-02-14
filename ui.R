# Header

header <- dashboardHeader(title = "Simulateur de garde partagée")

# Sidebar

sidebar <- dashboardSidebar(
  sidebarMenu( # Liste des onglets
    menuItem("Mode d'emploi", 
             tabName = "manuel",
             icon = icon("book-open")),
    
    menuItem("Simulateur",
             tabName = "simu",
             icon = icon("calculator")),
    
    menuItem("Résumé",
             tabName = "resume",
             icon = icon("table-list"))
  )
)

# Body

body <- dashboardBody(
  useShinyjs(), 
  tabItems(
    
    # Contenu lié à l'onglet "Mode d'emploi"
    tabItem(
      tabName = "manuel",
      h3("Mode d'emploi"),
      hr(),
      fluidRow(
        box(
          width = 12,
          h3("Hypothèses prises en compte"),
          infoBox("Charges sociales salariales",
                  "23% du brut",
                  icon = icon("credit-card"),
                  fill = TRUE),
          infoBox("Charges sociales patronales", 
                  "41.7% du brut", 
                  icon = icon("credit-card"),
                  fill = TRUE),
          infoBox("Nombre d'heures semaine maximum", 
                  "48",
                  icon = icon("business-time"), 
                  fill = TRUE)
        )
      ),
      hr(),
      fluidRow(
        box(
          width = 12,
          p("Dans ce modèle, on suppose plusieurs choses supplémentaires"),
          tags$ul(
            tags$li(
              "Les heures sont majorées de 25% à partir de la 40e heure"
            ),
            tags$li(
              "Le salaire annualisé correspond au salaire hebdomadaire multiplé par le nombre de semaine travaillées. Le tout divisé par 12"
            ),
            tags$li(
              "Mêmes vacances pour les deux familles"
            ),
            tags$li(
              "Deduction 50% charges sociales (patronales + salariales), dans la limite de 452 euros par mois + 2 euros de l’heure"
            ), 
            tags$li(
              "Crédit d’impôt = 50% reste à charge, 7500 euros annuel au max"
            ),
            tags$li(
              "Dans le cas où les revenus dépassent le plafond, on a 177 euros de cmg"
            )
          )
        )
      )
    ),
    
    # Contenu lié à l'onglet "Simulation"
    tabItem(
      tabName = "simu",
      h3("Partie simulation"),
      hr(),
      fluidRow(
        box(
          width = 4,
          h3("Informations sur la Famille 1"),
          numericInput("revenu_f1", "Revenu mensuel (€) :",
                       value = 3000,
                       min = 0),
          sliderInput("heures_f1", "Heures/semaine pour la Famille 1 :",
                      min = 0,
                      max = 48,
                      value = 25,
                      step = 1)
        ),
        box(
          width = 4,
          h3("Informations sur la Famille 2"),
          numericInput("revenu_f2", 
                       "Revenu mensuel (€) :",
                       value = 2500,
                       min = 0),
          sliderInput("heures_f2",
                      "Heures/semaine pour la Famille 2 :",
                      min = 0,
                      max = 48,
                      value = 20,
                      step = 1)
        ),
        box(
          width = 4,
          h3("Paramètres généraux"),
          numericInput("salaire_brut", "Salaire brut horaire (€) :",
                       value = 12,
                       min = 0),
          numericInput("transport_bonus", "Coût de transport (€) :",
                       value = 50,
                       min = 0),
          numericInput("vacation_weeks", "Nombre de semaines de vacances :",
                       value = 5, 
                       min = 0,
                       max = 52),
          h3("Calcul par durée"),
          selectInput("duree_type", "Type de durée :", 
                      choices = c("jour", "mois"),
                      selected = "mois"),
          numericInput("duree_nb", "Nombre de jours ou mois :",
                       value = 1,
                       min = 1)
        )
      ),
      fluidRow("",
               align = "center", 
               actionButton("calculer", "Lancer la simulation")),
      hr(),
      fluidRow(id = "resultats_simu",
      fluidRow("",
               box(
                 title = "Données de la famille 1",
                 status = "primary",
                 solidHeader = TRUE,
                 DTOutput("resf1")
               ),
               box(
                 title = "Données de la famille 2",
                 status = "success",
                 solidHeader = TRUE,
                 DTOutput("resf2")
               )
      ),
      fluidRow("", 
               box(
                 title = "Données combinées des 2 familles",
                 status = "danger",
                 solidHeader = TRUE,
                 DTOutput("combinees")
               ),
               box(
                 title = "Informations sur le salaire de la nounou",
                 status = "info",
                 solidHeader = TRUE,
                 DTOutput("salairenounou")
               )
      ),
      fluidRow(
        align = "center",
          h3("Visualisation des résultats"),
          plotlyOutput("graphique") 
      ))
    ),
    
    # Contenu lié à l'onglet "Résumé"
    tabItem(
      tabName = "resume",
      h3("Résumé de l'outil de simulation"),
      p("On utilise un code pour décrire les différentes situations possibles"),
      tags$ul(
        tags$li("MF1 = Mercredi Famille 1 seule"),
        tags$li("MC = Mercredi commun")
      ),
      p("Par exemple, 1MC 2MF1 signifie :"),
      p("Un mercredi en commun et deux mercredis où seule la famille 1 fait garder son enfant."),
      DTOutput("resumes")
    )
  )
)


# Create the UI object

ui <- dashboardPage(
  header,
  sidebar,
  body
)