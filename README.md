if(!require(tidyverse)) install.packages("tidyverse")
if(!require(readxl)) install.packages("readxl")
library(tidyverse)
library(readxl)

windowsFonts(Helvetica = windowsFont("Arial"))

setwd("C:/Users/FATIMA DIALLO/Desktop/ThinkNeuro_Data")

wos_raw     <- read_excel("wos_data.xlsx")
scopus_raw  <- read_csv("scopus_data.csv", show_col_types = FALSE)
combined_raw <- bind_rows(wos_raw, scopus_raw) %>% distinct()

write_csv(combined_raw, "Full_Combined_Dataset.csv")

processed_authors <- combined_raw %>%
  filter(!is.na(Authors) & Authors != "") %>%
  mutate(
    Real_Citations = coalesce(as.numeric(Times.Cited..All.Databases), as.numeric(Cited.by), 0)
  ) %>%
  mutate(Author_Clean = strsplit(as.character(Authors), ";|,| and ")) %>%
  unnest(Author_Clean) %>%
  mutate(Author_Clean = str_trim(Author_Clean)) %>%
  filter(Author_Clean != "") %>%
  group_by(Article.Title) %>%
  mutate(Total_Authors_On_Paper = n()) %>%
  ungroup() %>%
  mutate(Fractional_Paper_Value = 1 / Total_Authors_On_Paper) %>%
  group_by(Author_Clean) %>%
  summarize(
    Real_Papers = sum(Fractional_Paper_Value, na.rm = TRUE),
    Real_Citations = sum(Real_Citations, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  arrange(desc(Real_Papers)) %>%
  slice_head(n = 10)

scale_factor <- max(processed_authors$Real_Citations) / max(processed_authors$Real_Papers)

p <- ggplot(processed_authors, aes(x = reorder(Author_Clean, -Real_Papers))) +
  geom_bar(aes(y = Real_Papers), stat = "identity", fill = "#003366", alpha = 0.85) +
  geom_line(aes(y = Real_Citations / scale_factor, group = 1), color = "#3399FF", linewidth = 1.2) +
  geom_point(aes(y = Real_Citations / scale_factor), color = "#000080", size = 3) +
  scale_y_continuous(
    name = "Fractional Paper Count (Bar)", 
    sec.axis = sec_axis(~.*scale_factor, name = "Total Citations (Line)")
  ) +
  theme_minimal() + 
  labs(
    title = "Top 10 Senior Authors Driving Research", 
    subtitle = "Calculated via Fractional Counting Analysis (Helvetica & Blue Palette)", 
    x = "Author Name"
  ) +
  theme(
    text             = element_text(family = "Helvetica"), 
    axis.text.x      = element_text(angle = 45, hjust = 1, family = "Helvetica", size = 9),
    axis.text.y.right= element_text(margin = margin(l = 5)),
    axis.title       = element_text(family = "Helvetica", face = "bold"),
    plot.title       = element_text(family = "Helvetica", face = "bold", size = 14),
    plot.subtitle    = element_text(family = "Helvetica", size = 10),
    panel.grid.minor = element_blank()
  )

ggsave("Author_Citations_DualAxis_1000dpi.png", plot = p, width = 11, height = 7, dpi = 1000)
