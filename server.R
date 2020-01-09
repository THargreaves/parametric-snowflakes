########################################
# NAME: Parametric Snowflakes (Server) #
# AUTHOR: Tim Hargreaves               #
# DATE: 2019-12-26                     #
########################################

library(dplyr)
library(ggvis)
library(shiny)

# based on this guide: https://ggvis.rstudio.com/interactivity.html#shiny-apps

server <- function(input, output, session) {
  
  points <- reactive({
    # scale inputs to appropriate ranges
    a <- input$stretch * 3 - 1.5
    b <- round(input$twist * 12 + 3)  # must be an integer
    c <- input$wiggle * 1.5
    
    # create table of coordinate pairs for 2000 values of t
    # function has period 4pi so create t sequence of that length
    tibble(t = seq(0, 4 * pi * input$length, length.out = 2000)) %>%
      mutate(
        x = sin(t / 2) - a * sin(b * t) * cos(t) - c * sin(10 * b * t) / 10,
        y = cos(t / 2) - a * sin(b * t) * sin(t) - c * cos(10 * b * t) / 10
      )
  })
  
  # ggvis can't take input directly but rather reactive values
  # corresponding to them
  background_col <- reactive(input$background)
  frost_col <- reactive(input$frost)
  outline_col <- reactive(input$outline)
  frost_thickness <- reactive(10 * input$thickness)
  outline_thickness <- reactive(3 * input$thickness)
  
  points %>%
    ggvis(~x, ~y) %>%
    # only way to set background colour as of 2019 is by drawing a rectange
    layer_rects(x = -2.5, x2 = 2.5, y = -2.5, y2 = 2.5, 
                fill := background_col) %>%
    layer_paths(stroke := frost_col, 
                strokeWidth := frost_thickness) %>%
    layer_paths(stroke := outline_col, 
                strokeWidth := outline_thickness) %>%
    hide_axis("x") %>%
    hide_axis("y") %>%
    # it can be shown that for the range of inputs specified above
    # the x/y coordinates almost never exceed a magnitude of 2.5
    scale_numeric("x", domain = c(-2.5, 2.5)) %>%
    scale_numeric("y", domain = c(-2.5, 2.5)) %>%
    set_options(duration = 2000) %>%
    bind_shiny("plot", "plot_ui")
  
  observeEvent(input$randomise, {
    updateSliderInput(session, 'stretch', value = runif(1))
    updateSliderInput(session, 'twist', value = runif(1))
    updateSliderInput(session, 'wiggle', value = runif(1))
  })
}