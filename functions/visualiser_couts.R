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
    labs(x = "Type de coût",
         y = "Montant (€)") +
    theme_minimal() +
    theme(plot.title = element_text(vjust = .5)) +
    scale_x_discrete(labels=c("Coût initial famille 1",
                                "Coût initial famille 2",
                                "Reste à payer famille 1",
                                "Reste à payer famille 2")) +
    theme(legend.position = "none")
}