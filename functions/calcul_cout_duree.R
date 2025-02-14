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
