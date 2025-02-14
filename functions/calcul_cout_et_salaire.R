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
  
  # Calcul des heures en commun et des heures spécifiques pour chaque fammille
  heures_communes_mois <- min(heures_f1_mois, heures_f2_mois)
  heures_specifiques_f1_mois <- max(0, heures_f1_mois - heures_communes_mois)
  heures_specifiques_f2_mois <- max(0, heures_f2_mois - heures_communes_mois)
  
  # Gestion des heures normales et supplémentaires
  heures_norm_communes_mois <- min(40 * 4, heures_communes_mois)  
  heures_supp_communes_mois <- max(0, heures_communes_mois - (40 * 4))
  
  heures_norm_f1_mois <- min(40 * 4, heures_specifiques_f1_mois)  
  heures_supp_f1_mois <- max(0, heures_specifiques_f1_mois - (40 * 4))
  
  heures_norm_f2_mois <- min(40 * 4, heures_specifiques_f2_mois)  
  heures_supp_f2_mois <- max(0, heures_specifiques_f2_mois - (40 * 4))
  
  # Calcul des coûts
  cout_communs <- (salaire_brut * heures_norm_communes_mois) + (salaire_brut * 1.25 * heures_supp_communes_mois)
  cout_f1 <- (salaire_brut * heures_norm_f1_mois) + (salaire_brut * 1.25 * heures_supp_f1_mois)
  cout_f2 <- (salaire_brut * heures_norm_f2_mois) + (salaire_brut * 1.25 * heures_supp_f2_mois)
  
  # Répartition des coûts des heures communes (50%-50%)
  cout_f1 <- cout_f1 + (cout_communs / 2)
  cout_f2 <- cout_f2 + (cout_communs / 2)
  
  # Ajustement pour les vacances
  cout_f1 <- cout_f1 * (1 - (vacances - 5) / 52)
  cout_f2 <- cout_f2 * (1 - (vacances - 5) / 52)
  
  # Calcul du salaire brut mensuel total
  brut_mois <- cout_f1 + cout_f2  
  
  # Calcul du salaire net mensuel (77 % du brut)
  net_mois <- brut_mois * 0.77 + transport_bonus * 0.75
  
  # Répartition du transport bonus
  cout_f1 <- cout_f1 + (transport_bonus * 0.75) / 2
  cout_f2 <- cout_f2 + (transport_bonus * 0.75) / 2
  
  tibble(
    brut_mensuel = brut_mois,
    net_mensuel = net_mois,
    cout_f1 = cout_f1,
    cout_f2 = cout_f2,
    total_cout = cout_f1 + cout_f2
  )
}