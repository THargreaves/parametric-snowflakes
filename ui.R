####################################
# NAME: Parametric Snowflakes (UI) #
# AUTHOR: Tim Hargreaves           #
# DATE: 2019-12-26                 #
####################################

library(colourpicker)
library(ggvis)
library(shiny)
library(shinydashboard)

# based on this guide: https://ggvis.rstudio.com/interactivity.html#shiny-apps

dashboardPage(
  dashboardHeader(title = 'Parametric Snowflakes'),
  dashboardSidebar(
    sidebarMenu(
      actionButton('randomise', 'Randomise Snowflake', icon = icon('dice')),
      menuItem('Parameters', icon = icon('cogs'), startExpanded = TRUE,
               sliderInput('stretch', 'Stretch', 0, 1, runif(1)),
               sliderInput('twist', 'Twist', 0, 1, runif(1)),
               sliderInput('wiggle', 'Wiggle', 0, 1, runif(1))
      ),
      menuItem('Appearance', icon = icon('paint-brush'),
               colourInput('background', 'Background', '#0F4359'),
               colourInput('frost', 'Frost', '#C6FBFF'),
               colourInput('outline', 'Outline', '#FFFFFF'),
               sliderInput('thickness', 'Thickness', 0, 1, 0.5),
               sliderInput('length', 'Length', 0, 1, 1)
      ),
      # it's not clear what this does but is included in the example
      uiOutput("plot_ui")
    )
  ),
  dashboardBody(
    ggvisOutput("plot")
  )
)