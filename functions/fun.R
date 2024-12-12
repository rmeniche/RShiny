# les librairies 
library(dplyr)
library(tidyr)
library(ggplot2)
library(purrr)

# 1. Vérification des règles légales
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
calculer_cout_base <- function(salaire_brut, heures_f1, heures_f2, vacances) {
  cout_heure_partage <- salaire_brut / 2
  
  cout_f1 <- (cout_heure_partage * min(heures_f1, heures_f2)) + 
    ((salaire_brut * 1.25) * max(0, heures_f1 - heures_f2))
  
  cout_f2 <- (cout_heure_partage * min(heures_f1, heures_f2)) + 
    ((salaire_brut * 1.25) * max(0, heures_f2 - heures_f1))
  
  cout_f1 <- (cout_f1 * (52 - vacances) / 52)*4
  cout_f2 <- (cout_f2 * (52 - vacances) / 52)*4
  
  tibble(
    cout_f1 = cout_f1,
    cout_f2 = cout_f2
  )
}

#4. Calcul des déductions légales
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
calculer_reste_a_payer <- function(cout_f1, cout_f2, deductions_f1, deductions_f2, credit_f1, credit_f2) {
  reste_f1 <- cout_f1 - deductions_f1 - credit_f1
  reste_f2 <- cout_f2 - deductions_f2 - credit_f2
  
  tibble(
    reste_f1 = reste_f1,
    reste_f2 = reste_f2
  )
}

#7. Fonction principale pour tout calculer
calculer_tous_les_couts <- function(salaire_net, salaire_brut, transport_bonus, heures_f1, heures_f2, vacances) {
  
  salaire <- calculer_salaire( salaire_brut,transport_bonus, heures_f1, heures_f2)
  
  cout_base <- calculer_cout_base(salaire_brut, heures_f1, heures_f2, vacances)
  
  deductions <- calculer_deductions(cout_base$cout_f1, cout_base$cout_f2, heures_f1, heures_f2)
  
  credits <- calculer_credit_impot(cout_base$cout_f1, cout_base$cout_f2, deductions$deductions_f1, deductions$deductions_f2)
  
  reste <- calculer_reste_a_payer(cout_base$cout_f1, cout_base$cout_f2,
                                  deductions$deductions_f1, deductions$deductions_f2,
                                  credits$credit_f1, credits$credit_f2)
  
  resultats <- bind_cols(salaire, cout_base, deductions, credits, reste)
  return(resultats)
}

#8. Fonction de visualisation
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
