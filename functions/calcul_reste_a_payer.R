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