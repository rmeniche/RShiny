# 1. Vérification des règles légales
#' Title
#'
#' @param heures_f1 
#' @param heures_f2 
#'
#' @return
#' @export
#'
#' @examples
verifier_heures <- function(heures_f1, heures_f2) {
  
  if (heures_f1 > 48 || heures_f2 > 48) {
    return("Erreur : Les heures par semaine ne peuvent pas dépasser 48.")
  }
  if (heures_f1 < 0 || heures_f2 < 0) {
    return("Erreur : Les heures par semaine doivent être positives.")
  }
  return(NULL)  # Pas d'erreurs
}

# 2.calcul le salaire net de la nounou
#' Title
#'
#' @param salaire_brut 
#' @param transport_bonus 
#' @param heures_f1_semaine 
#' @param heures_f2_semaine 
#'
#' @return
#' @export
#'
#' @examples
calculer_salaire <- function(salaire_brut, transport_bonus, heures_f1_semaine, heures_f2_semaine) {
  
  # Nombre total d'heures hebdomadaires
  heures_totales_semaine <- heures_f1_semaine + heures_f2_semaine
  
  # Conversion des heures hebdomadaires en heures mensuelles
  heures_totales_mois <- heures_totales_semaine * 4
  
  # salaire brut mensuel
  brut_mois <- salaire_brut * heures_totales_mois + transport_bonus
  
  # salaire net mensuel (net = 77 % du brut)
  net_mois <- brut_mois * 0.77
  
  tibble(
    heures_totales_semaine = heures_totales_semaine,
    heures_totales_mois = heures_totales_mois,
    brut_mensuel = brut_mois,
    net_mensuel = net_mois
  )
}


#3. Calcul du coût partagé et spécifique
#' Title
#'
#' @param salaire_brut 
#' @param heures_f1 
#' @param heures_f2 
#' @param vacances 
#'
#' @return
#' @export
#'
#' @examples
calculer_cout_base <- function(salaire_brut, transport_bonus, heures_f1, heures_f2, vacances) {
  # Heures mensuelles pour chaque famille
  heures_f1_mois <- heures_f1 * 4
  heures_f2_mois <- heures_f2 * 4
  
  # Calcul du salaire brut mensuel total
  salaire <- calculer_salaire(salaire_brut, transport_bonus, heures_f1, heures_f2)
  salaire_brut_mois <- salaire$brut_mensuel
  
  # Heures communes et spécifiques
  heures_communes_mois <- min(heures_f1_mois, heures_f2_mois)
  heures_supp_f1_mois <- max(0, heures_f1_mois - heures_communes_mois)
  heures_supp_f2_mois <- max(0, heures_f2_mois - heures_communes_mois)
  
  # Proportions des heures pour calculer le partage
  proportion_communes_f1 <- heures_communes_mois / (heures_f1_mois + heures_f2_mois)
  proportion_communes_f2 <- heures_communes_mois / (heures_f1_mois + heures_f2_mois)
  
  # Répartition des coûts ajustée pour garantir l'égalité au salaire brut
  cout_communes <- salaire_brut_mois * (heures_communes_mois / (heures_f1_mois + heures_f2_mois))
  cout_f1 <- (proportion_communes_f1 * cout_communes) + 
    (salaire_brut * heures_supp_f1_mois)
  cout_f2 <- (proportion_communes_f2 * cout_communes) + 
    (salaire_brut * heures_supp_f2_mois)
  
  
  total_cout <- cout_f1 + cout_f2
  ajustement <- salaire_brut_mois / total_cout
  
  cout_f1 <- cout_f1 * ajustement
  cout_f2 <- cout_f2 * ajustement
  
  tibble(
    cout_f1 = cout_f1,
    cout_f2 = cout_f2,
    salaire_brut_mois = salaire_brut_mois,
    total_cout = cout_f1 + cout_f2
  )
}


#4. Calcul des déductions légales
#' Title
#'
#' @param cout_f1 
#' @param cout_f2 
#' @param heures_f1 
#' @param heures_f2 
#'
#' @return
#' @export
#'
#' @examples
calculer_deductions <- function(cout_f1, cout_f2, heures_f1, heures_f2) {
  
  # Déduction pour les charges sociales (50% dans la limite de 452 €/mois)
  deduction_f1_charges <- min(cout_f1 * 0.5, 452)
  deduction_f2_charges <- min(cout_f2 * 0.5, 452)
  
  # Déduction basée sur les heures travaillées (2€/h sur 4 semaines)
  deduction_par_heure_f1 <- heures_f1 * 2 * 4
  deduction_par_heure_f2 <- heures_f2 * 2 * 4
  
  # Calcul des déductions totales pour chaque famille
  deductions_totales_f1 <- min(deduction_f1_charges + deduction_par_heure_f1, cout_f1)
  deductions_totales_f2 <- min(deduction_f2_charges + deduction_par_heure_f2, cout_f2)
  
  tibble(
    deductions_f1 = deductions_totales_f1,
    deductions_f2 = deductions_totales_f2
  )
}


#5. Calcul du crédit d'impôt
#' Title
#'
#' @param cout_f1 
#' @param cout_f2 
#' @param deductions_f1 
#' @param deductions_f2 
#'
#' @return
#' @export
#'
#' @examples
calculer_credit_impot <- function(cout_f1, cout_f2, deductions_f1, deductions_f2) {
  
  reste_a_charge_f1 <- cout_f1 - deductions_f1
  reste_a_charge_f2 <- cout_f2 - deductions_f2
  
  credit_f1 <- min(reste_a_charge_f1 * 0.5, 7500 / 12)
  credit_f2 <- min(reste_a_charge_f2 * 0.5, 7500 / 12)
  
  tibble(
    credit_f1 = credit_f1,
    credit_f2 = credit_f2
  )
}

#6. Calcul du reste à payer après crédit d'impôt
#' Title
#'
#' @param cout_f1 
#' @param cout_f2 
#' @param deductions_f1 
#' @param deductions_f2 
#' @param credit_f1 
#' @param credit_f2 
#'
#' @return
#' @export
#'
#' @examples
calculer_reste_a_payer <- function(cout_f1, cout_f2, deductions_f1, deductions_f2, credit_f1, credit_f2) {
  
  reste_f1 <- cout_f1 - deductions_f1 - credit_f1
  reste_f2 <- cout_f2 - deductions_f2 - credit_f2
  
  tibble(
    reste_f1 = reste_f1,
    reste_f2 = reste_f2
  )
}

#7. Fonction principale pour tout calculer
#' Title
#'
#' @param salaire_net 
#' @param salaire_brut 
#' @param transport_bonus 
#' @param heures_f1 
#' @param heures_f2 
#' @param vacances 
#'
#' @return
#' @export
#'
#' @examples
calculer_tous_les_couts <- function(salaire_net, salaire_brut, transport_bonus, heures_f1, heures_f2, vacances) {
  
  
  salaire <- calculer_salaire( salaire_brut,transport_bonus, heures_f1, heures_f2)
  
  cout_base <- calculer_cout_base(salaire_brut,transport_bonus, heures_f1, heures_f2, vacances)
  
  deductions <- calculer_deductions(cout_base$cout_f1, cout_base$cout_f2, heures_f1, heures_f2)
  
  credits <- calculer_credit_impot(cout_base$cout_f1, cout_base$cout_f2, deductions$deductions_f1, deductions$deductions_f2)
  
  reste <- calculer_reste_a_payer(cout_base$cout_f1, cout_base$cout_f2,
                                  deductions$deductions_f1, deductions$deductions_f2,
                                  credits$credit_f1, credits$credit_f2)
  
  resultats <- bind_cols(salaire, cout_base, deductions, credits, reste)
  return(resultats)
}

#8. Fonction de visualisation
#' Title
#'
#' @param resultats 
#'
#' @return
#' @export
#'
#' @examples
visualiser_couts <- function(resultats) {
  
  resultats %>%
    pivot_longer(cols = c(cout_f1, cout_f2, reste_f1, reste_f2),
                 names_to = "type", values_to = "valeur") %>%
    ggplot(aes(x = type, y = valeur, fill = type)) +
    geom_col(show.legend = FALSE) +
    labs(title = "Répartition des coûts et du reste à payer",
         x = "Type de coût",
         y = "Montant (€)") +
    theme_minimal()
}

#9 calcul du reste sur le salaire des familles
#' Title
#'
#' @param revenu_f1 
#' @param revenu_f2 
#' @param cout_f1 
#' @param cout_f2 
#'
#' @return
#' @export
#'
#' @examples
calculer_reste_salaire_familles <- function(revenu_f1, revenu_f2, cout_f1, cout_f2) {
  
  
  reste_salaire_f1 <- revenu_f1 - cout_f1
  reste_salaire_f2 <- revenu_f2 - cout_f2
  
  # Vérification si le reste est négatif
  if (reste_salaire_f1 < 0) {
    warning("Attention : Famille 1 dépasse son revenu mensuel.")
  }
  if (reste_salaire_f2 < 0) {
    warning("Attention : Famille 2 dépasse son revenu mensuel.")
  }
  
  tibble(
    revenu_f1 = revenu_f1,
    revenu_f2 = revenu_f2,
    cout_f1 = cout_f1,
    cout_f2 = cout_f2,
    reste_salaire_f1 = reste_salaire_f1,
    reste_salaire_f2 = reste_salaire_f2
  )
}

# 9 calcule sur une duree

calculer_cout_duree <- function(salaire_brut, transport_bonus, heures_f1, heures_f2, vacances, duree = "mois", nb_duree = 1) {
  # Valider l'entrée pour la durée
  if (!duree %in% c("jour", "mois")) {
    stop("La durée doit être soit 'jour' soit 'mois'.")
  }
  
  if (duree == "jour") {
    cout <- calculer_cout_base(salaire_brut, transport_bonus, heures_f1, heures_f2)
    
    cout_f1 <- cout$cout_f1 /30 # hors week ends 5j/semainee
    cout_f2 <- cout$cout_f2 /30
    
    total_cout <- (cout_f1 + cout_f2) * nb_duree 
    
  } else if (duree == "mois") {
    cout <- calculer_cout_base(salaire_brut, transport_bonus, heures_f1, heures_f2)
    
    cout_f1 <- cout$cout_f1
    cout_f2 <- cout$cout_f2
    
    # Coût total pour la période en mois
    total_cout <- (cout_f1 + cout_f2) * nb_duree
  }
  
  tibble(
    duree = duree,
    nb_duree = nb_duree,
    cout_f1 = cout_f1 * nb_duree,
    cout_f2 = cout_f2 * nb_duree,
    total_cout = total_cout
  )
}



