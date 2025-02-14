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
calcul_tous_les_couts <- function(salaire_net,
                                  salaire_brut,
                                  transport_bonus,
                                  heures_f1, 
                                  heures_f2,
                                  vacances) {
  
  
  salaire <- calcul_cout_et_salaire(salaire_brut, 
                                    transport_bonus,
                                    heures_f1,
                                    heures_f2, 
                                    vacances)
  
  deductions <- calcul_deductions(salaire$cout_f1,
                                  salaire$cout_f2, 
                                  heures_f1,
                                  heures_f2, 
                                  salaire$brut_mensuel,
                                  salaire$net_mensuel)
  
  credits <- calcul_credit_impot(salaire$cout_f1,
                                 salaire$cout_f2,
                                 deductions$deductions_f1, 
                                 deductions$deductions_f2)
  
  reste <- calcul_reste_a_payer(salaire$cout_f1,
                                salaire$cout_f2,
                                deductions$deductions_f1,
                                deductions$deductions_f2,
                                credits$credit_f1,
                                credits$credit_f2)
  
  resultats <- bind_cols(salaire, deductions, credits, reste)
  return(resultats)
}