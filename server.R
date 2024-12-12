# Charger les fonctions
source("functions/fun.R")

  server <- function(input, output){
    observeEvent(input$calculer, {
      
      # Calculer les coûts pour chaque famille
      resultats <- calculer_tous_les_couts(
        salaire_brut = input$salaire_brut,
        transport_bonus = input$transport_bonus,
        heures_f1 = input$heures_f1,
        heures_f2 = input$heures_f2,
        vacances = input$vacation_weeks
      )
      
      # Calculer le reste du revenu après paiement
      reste_revenus <- calculer_reste_salaire_familles(
        revenu_f1 = input$revenu_f1,
        revenu_f2 = input$revenu_f2,
        cout_f1 = resultats$cout_f1,
        cout_f2 = resultats$cout_f2
      )
      
      # pour afficher les résultats
      output$resultats <- renderText({
        paste(
          "Salaire mensuel brut de la nounou :", round(resultats$brut_mensuel, 2), "€",
          "\nSalaire mensuel net de la nounou :", round(resultats$net_mensuel, 2), "€",
          "\nCoût Famille 1 avant déductions :", round(resultats$cout_f1, 2), "€",
          "\nCoût Famille 2 avant déductions :", round(resultats$cout_f2, 2), "€",
          "\nCredit impot Famille 1 :", round(resultats$credit_f1, 2), "€",
          "\nCredit impot Famille 2 :", round(resultats$credit_f2, 2), "€",
          "\nCoût Famille 1 apres déductions :", round(resultats$reste_f1, 2), "€",
          "\nCoût Famille 2 apres déductions :", round(resultats$reste_f2, 2), "€",
          "\nReste Famille 1 après paiement :", round(reste_revenus$reste_salaire_f1, 2), "€",
          "\nReste Famille 2 après paiement :", round(reste_revenus$reste_salaire_f2, 2), "€"
        )
      })
      
      # graphique des coûts
      output$graphique <- renderPlot({
        visualiser_couts(resultats)
      })
    })
  }