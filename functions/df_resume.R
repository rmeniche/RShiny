#' Title
#'
#' @return
#' @export
#'
#' @examples
df_resume <- function() {
  
  code_desc <- c("2MC", "1MF1 1MC", "2MF1 2MC", "2MF1, 1MC", "3MF1, 1MC", "2MF1, 1MC", "3MF1", "2MF1")
  nb_h_mercredi <- c(10, 10, 8, 8, 8, 10, 8, 8)
  nb_mercredi_f1 <- c(0, 1, 2, 2, 3, 2, 3, 2)
  nb_mercredi_commun <- c(2, 1, 2, 1, 1, 1, 0, 0)
  nb_heures <- c(45, 45, 48, 46, 48, 47.5, 46, 44)
  paniers <- rep(6, 8)
  sal_hor <- c(11.2, 11.2, 10.5, 11, 10.5, 10.5, 11, 11.5)
  sal_net_avec_prime <- c(2170, 2170, 2206, 2191, 2206, 2175, 2192, 2167)
  prix_f1_apres_credit <- c(589, 647, 727, 637, 816, 745, 825, 727)
  prix_f2_apres_credit <- c(589, 544, 528, 560, 494, 502, 487, 515)
  
  
  data_resume <- data.frame(
    code_desc = code_desc,
    nb_h_mercredi = nb_h_mercredi,
    nb_mercredi_f1 = nb_mercredi_f1,
    nb_mercredi_commun = nb_mercredi_commun,
    nb_heures = nb_heures,
    paniers = paniers,
    sal_hor = sal_hor,
    sal_net_avec_prime = sal_net_avec_prime,
    prix_f1_apres_credit = prix_f1_apres_credit,
    prix_f2_apres_credit = prix_f2_apres_credit
  )
  
  data_resume
}
