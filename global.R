# Librairies

library(tidyverse)
library(shiny)
library(shinydashboard)
library(dplyr)
library(shinyjs)
library(DT)
library(plotly)
library(tidyr)
library(ggplot2)
library(purrr)


# Constantes

charge_sociale <- .23
max_h <- 48


# Fonctions

source("functions/calcul_cout_duree.R")
source("functions/calcul_cout_et_salaire.R")
source("functions/calcul_credit_impot.R")
source("functions/calcul_deductions.R")
source("functions/calcul_reste_a_payer.R")
source("functions/calcul_reste_salaire_familles.R")
source("functions/calcul_tous_les_couts.R")
source("functions/visualiser_couts.R")
source("functions/df_resume.R")