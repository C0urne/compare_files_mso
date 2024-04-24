library(tidyverse)
library(openxlsx)
library(daff)


# Import data ----
v1 <- read.xlsx("data/test_data/P155 - Bourgogne Franche Comté - Suivi effectifs 2024 Région .xlsm", sheet = "Agents")
v2 <- read.xlsx("data/test_data/P155 - Bourgogne Franche Comté -Suivi effectifs 2024 .xlsm", sheet = "Agents")

# daff_diff
d <- daff::diff_data(v1, v2)

s <- daff::render_diff(d)


























































