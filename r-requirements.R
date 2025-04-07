# Install required dependencies first
deps <- c(
    'purrr',
    'tidyr',
    'readr',
    'cpp11',
    'broom',
    'dbplyr',
    'ggplot2',
    'googledrive',
    'googlesheets4',
    'haven',
    'lubridate',
    'modelr',
    'readxl',
    'ragg'
)

# Install dependencies
install.packages(deps, repos='https://cloud.r-project.org/')

# Install main packages
install.packages(c(
    'tidyverse',
    'IRkernel'
), repos='https://cloud.r-project.org/')

# Setup IRkernel
IRkernel::installspec() 