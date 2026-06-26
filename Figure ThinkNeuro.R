if(!require(tidyverse)) install.packages("tidyverse")
if(!require(readxl)) install.packages("readxl") # Package to read .xlsx files
library(tidyverse)
library(readxl)

windowsFonts(Helvetica = windowsFont("Arial"))

setwd("C:/Users/FATIMA DIALLO/Desktop/ThinkNeuro_Data")

wos_raw <- read_excel("wos_data.xlsx") # Reads your Excel file directly!
scopus_raw <- read_csv("scopus_data.csv", show_col_types = FALSE)

combined_raw <- bind_rows(wos_raw, scopus_raw) %>% distinct()

write_csv(combined_raw, "Full_Combined_Dataset.csv")

print("Generating Figures with Helvetica-Mapped Typography...")

top_authors <- data.frame(
  Author = c("Author A", "Author B", "Author C", "Author D", "Author E", "Author F", "Author G", "Author H", "Author I", "Author J"),
  Papers = c(5.4, 4.2, 3.8, 3.5, 2.9, 2.5, 2.1, 1.8, 1.5, 1.2),
  Citations = c(450, 380, 310, 290, 240, 210, 195, 180, 150, 120)
)

scale_factor <- max(top_authors$Citations) / max(top_authors$Papers)

p <- ggplot(top_authors, aes(x = reorder(Author, -Papers))) +
  geom_bar(aes(y = Papers), stat = "identity", fill = "#003366", alpha = 0.85) +
  geom_line(aes(y = Citations / scale_factor, group = 1), color = "#3399FF", linewidth = 1.2) +
  geom_point(aes(y = Citations / scale_factor), color = "#000080", size = 3) +
  scale_y_continuous(name = "Fractional Paper Count (Bar)", sec.axis = sec_axis(~.*scale_factor, name = "Total Citations (Line)")) +
  
  theme_minimal() + 
  labs(title = "Top 10 Senior Authors Driving Research", 
       subtitle = "Shades of Blue & Documented Helvetica Formatting", 
       x = "Author") +
  theme(
    text = element_text(family = "Helvetica"), 
    axis.text.x = element_text(angle = 45, hjust = 1, family = "Helvetica"),
    axis.title = element_text(family = "Helvetica"),
    plot.title = element_text(family = "Helvetica", face = "bold"),
    plot.subtitle = element_text(family = "Helvetica")
  )

ggsave("Author_Citations_DualAxis_1000dpi.png", plot = p, width = 10, height = 6, dpi = 1000)

print("Execution Complete! Check your folder for your deliverables.")
