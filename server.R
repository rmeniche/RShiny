# Charger les fonctions
  server <- function(input, output){
    
    hide("resultats_simu")
    
    observeEvent(input$calculer, {
      
      toggle("resultats_simu")
      
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
      
      output$resf1 <- renderDT(
        {
          df_res1 <- data.frame(
            Donnees = c(
                        "Coût Famille 1 avant déductions",
                        "Credit impot Famille 1",
                        "Coût Famille 1 après déductions",
                        "Reste Famille 1 après paiement",
                        "Famille 1 (Coût sur la durée)")
            ,
            Valeurs = c(
                        round(resultats$cout_f1, 2),
                        round(resultats$credit_f1, 2),
                        round(resultats$reste_f1, 2),
                        round(reste_revenus$reste_salaire_f1, 2),
                        round(cout_duree$cout_f1, 2)))
          
          datatable(df_res1,
                    colnames = c("Données", "Quantité en euros"),
                    options = list(
                      paging = FALSE,
                      dom = 't'
                    ))
        }
      )
      
      # pour afficher les résultats
      output$resf2 <- renderDT({
        
        df_res2 <- data.frame(
          Donnees = c(
                      "Coût Famille 2 avant déductions",
                      "Credit impot Famille 2",
                      "Coût Famille 2 après déductions",
                      "Reste Famille 2 après paiement",
                      "Famille 2 (Coût sur la durée)")
          ,
          Valeurs = c(
                      round(resultats$cout_f2, 2),
                      round(resultats$credit_f2, 2),
                      round(resultats$reste_f2, 2),
                      round(reste_revenus$reste_salaire_f2, 2),
                      round(cout_duree$cout_f2, 2)))
        
        datatable(df_res2,
                  colnames = c("Données", "Quantités en euros"),
                  options = list(
                    paging = FALSE,
                    dom = 't'
                  ))
      })
      
      output$salairenounou <- renderDT({
        df_resultats <- data.frame(
          Donnees = c("Salaire mensuel brut de la nounou",
                      "Salaire mensuel net de la nounou")
          ,
          Valeurs = c(round(resultats$brut_mensuel, 2),
                      round(resultats$net_mensuel, 2)))
        
        datatable(df_resultats,
                  colnames = c("Données", "Salaire en euros"),
                  options = list(
                    paging = FALSE,
                    dom = 't'
                  ))
      })
      
      output$combinees <- renderDT({
        df_resultats <- data.frame(
          Donnees = c(
                      "Total (Coût sur la durée)")
          ,
          Valeurs = c(
                      round(cout_duree$total_cout, 2)))
        
        datatable(df_resultats,
                  colnames = c("Donnée", "Quantité en euros"),
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
                                 targets = 1:10)), # Centrage des valeurs 
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
                     "Salaire net F1",
                     "Prix F1",
                     "Prix F2"
                     )
      )
    })
  }