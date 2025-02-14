# Charger les fonctions
  server <- function(input, output){
    observeEvent(input$calculer, {
      
      # calcul les coûts pour chaque famille
      resultats <- calcul_tous_les_couts(
        salaire_brut = input$salaire_brut,
        transport_bonus = input$transport_bonus,
        heures_f1 = input$heures_f1,
        heures_f2 = input$heures_f2,
        vacances = input$vacation_weeks
      )
      
      # calcul le reste du revenu après paiement
      reste_revenus <- calcul_reste_salaire_familles(
        revenu_f1 = input$revenu_f1,
        revenu_f2 = input$revenu_f2,
        cout_f1 = resultats$cout_f1,
        cout_f2 = resultats$cout_f2
      )
      
      # calcul les coûts pour une durée donnée
      cout_duree <- calcul_cout_duree(
        salaire_brut = input$salaire_brut,
        transport_bonus = input$transport_bonus,
        heures_f1 = input$heures_f1,
        heures_f2 = input$heures_f2,
        vacances = input$vacation_weeks,
        duree = input$duree_type,
        nb_duree = input$duree_nb
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
          "\nReste Famille 2 après paiement :", round(reste_revenus$reste_salaire_f2, 2), "€",
          "\n\nCoût sur la durée (", input$duree_nb, input$duree_type, ") :",
          "\nFamille 1 :", round(cout_duree$cout_f1, 2), "€",
          "\nFamille 2 :", round(cout_duree$cout_f2, 2), "€",
          "\nTotal :", round(cout_duree$total_cout, 2), "€"
        )
      })
      
      # graphique des coûts
      output$graphique <- renderPlot({
        visualiser_couts(resultats)
      })
    })
    
    output$resumes <- renderDT({
      df_res <- df_resume()
      
      datatable(
        df_res,
        options = list(
          paging = FALSE,
          dom = 't'
        ),
        colnames = c("Code Description",
                     "Nb heures mercredi",
                     "Nb mercredis F1",
                     "Nb mecredis communs",
                     "Nb heures nounou",
                     "Panier", 
                     "Salaire horaire",
                     "Salaire net F1 après prime nounou",
                     "Prix F1",
                     "Prix F2"
                     )
      )
    })
  }