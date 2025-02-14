#9 calcul du reste sur le salaire des familles
#' Title
#'
#' @param revenu_f1 
#' @param revenu_f2 
#' @param reste_f1 
#' @param reste_f2 
#'
#' @return
#' @export
#'
#' @examples
calcul_reste_salaire_familles <- function(revenu_f1,
                                          revenu_f2,
                                          reste_f1,
                                          reste_f2) {
  
  
  reste_salaire_f1 <- revenu_f1 - reste_f1
  reste_salaire_f2 <- revenu_f2 - reste_f2
  
  # Vérification si le reste est négatif
  if (reste_salaire_f1 < 0) {
    message_erreur("Attention : Famille 1 dépasse son revenu mensuel.")
  }
  if (reste_salaire_f2 < 0) {
    message_erreur("Attention : Famille 2 dépasse son revenu mensuel.")
  }
  
  tibble(
    revenu_f1 = revenu_f1,
    revenu_f2 = revenu_f2,
    reste_f1 = reste_f1,
    reste_f2 = reste_f2,
    reste_salaire_f1 = reste_salaire_f1,
    reste_salaire_f2 = reste_salaire_f2
  )
}