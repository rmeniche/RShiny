#8. Fonction de visualisation
#' Title
#'
#' @param resultats 
#'
#' @return
#' @export
#'
#' @examples
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