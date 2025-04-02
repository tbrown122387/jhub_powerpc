# Install required R packages
packages <- c(
  # Core packages
  'IRkernel',
  
  # Data manipulation and analysis
  'tidyverse'
  
  # Add more packages here
)

# Install packages
install.packages(packages, repos='http://cran.rstudio.com/')

# Setup IRkernel
IRkernel::installspec(user = FALSE) 