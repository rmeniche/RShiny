message_erreur <- function(message) {
  showModal(
    modalDialog(
      title = "Attention !",
      message,
      easyClose = TRUE,
      footer = modalButton("Fermer")
    )
  )
}