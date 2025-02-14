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
