# AN

##############################
# install packages
##############################

library(kableExtra)
library(RColorBrewer)
library(shiny)
library(tidyverse)

##############################
# load data
##############################

race_eth <- c("AfricanAm", "AIAN", "Asian", "Filipino", "Latino", "PIsl", "White", "Multiple", "Not reported")

sc_en_tri$race_eth_name <- factor(sc_en_tri$race_eth_name, levels = race_eth)

##############################
# Define server logic
##############################

# shinyServer(function(input, output) {
#   observe()
#   output$district <- renderUI({
#     updateSelectInput("districts", "Select District", sc_en_district)
#   })

  
shinyServer(function(input, output, session) {
  observe({
    updateSelectInput(session, 
                      "County", 
                      choices = unique(sc_en_tri$COUNTY))
    })
  observe({
      updateSelectInput(session, 
                        "district", 
                        choices = sc_en_tri %>% 
                          filter(COUNTY == input$county) %>% 
                          dplyr::select(DISTRICT) %>% 
                          .[[1]])
  })
  observe({
    updateSelectInput(session,
                      "school",
                      choices = sc_en_tri %>% 
                        filter(DISTRICT == input$district) %>% 
                        dplyr::select(SCHOOL) %>% 
                        .[[1]])

  })
  # observe({
  #   updateSelectInput(session,
  #                     "grade_choice",
  #                     choices = sc_en_tri %>% 
  #                       filter(SCHOOL == input$school) %>% 
  #                       dplyr::select(grade) %>% 
  #                       .[[1]])
  #   
  # })
  output$column_plot <- renderPlot({
    # data
    school_data <- sc_en_tri %>%
      filter(SCHOOL == input$school) %>% 
      arrange(race_eth_name) %>% 
      group_by(gender, race_eth_name) %>% 
      summarize(total = sum(students))
    
    
    # ggplot
    ggplot(school_data, aes(x = reorder(race_eth_name, -total), y = total)) +
      geom_bar(stat = "identity", position = "dodge", aes(fill = race_eth_name)) +
      scale_fill_brewer(palette = "Spectral") +
      geom_text(aes(label = total),
                position = position_dodge(width = 0.9), vjust = -0.25) +
      facet_wrap(~gender) +
      theme_minimal() +
      theme(axis.ticks.y = element_blank(),
          axis.text.y = element_blank(),
          panel.grid = element_line(color = "white")) +
      labs(x = "Race",
           y = "Total students enrolled")

   })
  
  
  # output$school_table <- renderText({
  #   sc_en_final %>% 
  #     filter(SCHOOL == input$school |
  #              grade == input$grade_choice) %>% 
  #     select(gender, race_eth_name, students) %>% 
  #     knitr::kable()
  # })

})
