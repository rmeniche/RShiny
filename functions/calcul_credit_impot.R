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
calcul_credit_impot <- function(cout_f1,
                                cout_f2,
                                deductions_f1,
                                deductions_f2) {
  
  reste_a_charge_f1 <- cout_f1 - deductions_f1
  reste_a_charge_f2 <- cout_f2 - deductions_f2
  
  credit_f1 <- min(reste_a_charge_f1 * 0.5, 7500 / 12)
  credit_f2 <- min(reste_a_charge_f2 * 0.5, 7500 / 12)
  
  tibble(
    credit_f1 = max(credit_f1, 0),
    credit_f2 = max(credit_f2, 0)
  )
}