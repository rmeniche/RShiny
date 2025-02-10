# 2.calcul le salaire net de la nounou et le cout specifique pour chaque famille
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
calcul_cout_et_salaire <- function(salaire_brut, transport_bonus, heures_f1, heures_f2, vacances) {
  # Heures mensuelles pour chaque famille
  heures_f1_mois <- heures_f1 * 4
  heures_f2_mois <- heures_f2 * 4
  
  # Heures communes et supplémentaires
  #heures_communes_mois <- min(heures_f1_mois, heures_f2_mois)
  heures_norm_f1_mois <- min(40, heures_f1) * 4
  heures_norm_f2_mois <- min(40, heures_f2) * 4
  
  heures_supp_f1_mois <- max(0, heures_f1 - 40) * 4
  heures_supp_f2_mois <- max(0, heures_f2 - 40) * 4
  
  # Calcul des coûts pour chaque famille
  cout_f1 <- (salaire_brut * heures_norm_f1_mois) + (salaire_brut * 1.25 * heures_supp_f1_mois)
  cout_f2 <- (salaire_brut * heures_norm_f2_mois) + (salaire_brut * 1.25 * heures_supp_f2_mois)
  
  # Ajustement pour les vacances
  cout_f1 <- cout_f1 *(1 - (vacances - 5) / 52)
  cout_f2 <- cout_f2 *(1 - (vacances - 5) / 52)
  
  # Calcul du salaire brut mensuel total
  brut_mois <- cout_f1 + cout_f2 + transport_bonus
  
  # Calcul du salaire net mensuel (77 % du brut)
  net_mois <- brut_mois * 0.77
  
  cout_f1 <- cout_f1 + transport_bonus/2
  cout_f2 <- cout_f2 + transport_bonus/2
  
  tibble(
    brut_mensuel = brut_mois,
    net_mensuel = net_mois,
    cout_f1 = cout_f1,
    cout_f2 = cout_f2,
    total_cout = cout_f1 + cout_f2
  )
}

#3. Calcul des déductions légales
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
calcul_deductions <- function(cout_f1, cout_f2, heures_f1, heures_f2, brut_mensuel, net_mensuel) {
  
  charge <- (brut_mensuel - net_mensuel) + 0.25 * brut_mensuel
  
  # Déduction pour les charges sociales (50% dans la limite de 452 €/mois)
  deduction_f1_charges <- min(charge * 0.5, 452)
  deduction_f2_charges <- min(charge * 0.5, 452)
  
  # Déduction basée sur les heures travaillées (2€/h sur 4 semaines)
  deduction_par_heure_f1 <- heures_f1 * 2 * 4
  deduction_par_heure_f2 <- heures_f2 * 2 * 4
  
  # Calcul des déductions totales pour chaque famille
  deductions_totales_f1 <- min(deduction_f1_charges + deduction_par_heure_f1, charge)
  deductions_totales_f2 <- min(deduction_f2_charges + deduction_par_heure_f2, charge)
  
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
calcul_credit_impot <- function(cout_f1, cout_f2, deductions_f1, deductions_f2) {
  
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
calcul_reste_a_payer <- function(cout_f1, cout_f2, deductions_f1, deductions_f2, credit_f1, credit_f2) {
  
  reste_f1 <- cout_f1 - deductions_f1 
  reste_f2 <- cout_f2 - deductions_f2 
  
  tibble(
    reste_f1 = reste_f1,
    reste_f2 = reste_f2
  )
}

#7. Fonction principale pour tout calcul
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
calcul_tous_les_couts <- function(salaire_net, salaire_brut, transport_bonus, heures_f1, heures_f2, vacances) {
  salaire <- calcul_cout_et_salaire(salaire_brut, transport_bonus, heures_f1, heures_f2, vacances)
  
  deductions <- calcul_deductions(salaire$cout_f1, salaire$cout_f2, heures_f1, heures_f2, salaire$brut_mensuel, salaire$net_mensuel)
  
  credits <- calcul_credit_impot(salaire$cout_f1, salaire$cout_f2, deductions$deductions_f1, deductions$deductions_f2)
  
  reste <- calcul_reste_a_payer(salaire$cout_f1, salaire$cout_f2,
                                deductions$deductions_f1, deductions$deductions_f2,
                                credits$credit_f1, credits$credit_f2)
  
  resultats <- bind_cols(salaire, deductions, credits, reste)
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
calcul_reste_salaire_familles <- function(revenu_f1, revenu_f2, cout_f1, cout_f2) {
  
  
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
calcul_cout_duree <- function(salaire_brut, transport_bonus, heures_f1, heures_f2, vacances, duree = "mois", nb_duree = 1) {
  if (!duree %in% c("jour", "mois")) {
    stop("La durée doit être soit 'jour' soit 'mois'.")
  }
  
  cout <- calcul_cout_et_salaire(salaire_brut, transport_bonus, heures_f1, heures_f2, vacances)
  
  if (duree == "jour") {
    cout_f1 <- cout$cout_f1 / 30
    cout_f2 <- cout$cout_f2 / 30
  } else if (duree == "mois") {
    cout_f1 <- cout$cout_f1
    cout_f2 <- cout$cout_f2
  }
  
  total_cout <- (cout_f1 + cout_f2) * nb_duree
  
  tibble(
    duree = duree,
    nb_duree = nb_duree,
    cout_f1 = cout_f1 * nb_duree,
    cout_f2 = cout_f2 * nb_duree,
    total_cout = total_cout
  )
}



