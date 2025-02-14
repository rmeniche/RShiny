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
      output$resultats <- renderDT({
        
        df_resultats <- data.frame(
          Donnees = c("Salaire mensuel brut de la nounou",
                       "Salaire mensuel net de la nounou",
                       "Coût Famille 1 avant déductions",
                       "Coût Famille 2 avant déductions",
                       "Credit impot Famille 1",
                       "Credit impot Famille 2",
                       "Coût Famille 1 après déductions",
                       "Coût Famille 2 après déductions",
                       "Reste Famille 1 après paiement",
                       "Reste Famille 2 après paiement",
                       paste("Coût sur la durée (", input$duree_nb, input$duree_type, ")"),
                       "Famille 1 (Coût sur la durée)",
                       "Famille 2 (Coût sur la durée)",
                       "Total (Coût sur la durée)")
          ,
          Valeurs = c(round(resultats$brut_mensuel, 2),
                     round(resultats$net_mensuel, 2),
                     round(resultats$cout_f1, 2),
                     round(resultats$cout_f2, 2),
                     round(resultats$credit_f1, 2),
                     round(resultats$credit_f2, 2),
                     round(resultats$reste_f1, 2),
                     round(resultats$reste_f2, 2),
                     round(reste_revenus$reste_salaire_f1, 2),
                     round(reste_revenus$reste_salaire_f2, 2),
                     NA, # Placeholder for the duration text
                     round(cout_duree$cout_f1, 2),
                     round(cout_duree$cout_f2, 2),
                     round(cout_duree$total_cout, 2)))
        
        datatable(df_resultats,
                  colnames = c("Données", "Valeurs"),
                  options = list(
                    paging = FALSE,
                    dom = 't'
                  ))
      })
        
      # graphique des coûts
      output$graphique <- renderPlotly({
        visualiser_couts(resultats)
      })
    })
    
    output$resumes <- renderDT({
      df_res <- df_resume()
      
      datatable(
        df_res,
        options = list(
          columnDefs = list(list(className = 'dt-center',
                                 targets = 1:10), 
                            list(targets = 10,
                                 visible = FALSE)), # Centrage des valeurs 
          paging = FALSE,
          dom = 't'
        ),
        colnames = c("Situation (sur 4 mercredis)",
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