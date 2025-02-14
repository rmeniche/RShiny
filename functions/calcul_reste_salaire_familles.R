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