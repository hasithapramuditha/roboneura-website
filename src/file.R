# ==============================================================================
#               R CODE CHEATSHEET: DATA VISUALIZATION & PREPROCESSING
# ==============================================================================

# Load necessary libraries
library(dplyr)
library(ggplot2)
library(maps)
library(corrplot)
library(shiny)


# ==============================================================================
# 1. DATA PREPROCESSING & CLEANING
# ==============================================================================

# --- Handling Missing Values ---
x <- c(NA, 4, 9, NA, 3, NA)
is.na(x)                     # Identify missing values (returns TRUE/FALSE)
na.omit(x)                   # Remove missing values from a vector
as.vector(na.omit(x))        # Cleaner output for omitted values
mean(x, na.rm = TRUE)        # Ignore missing values in calculations
x[is.na(x)] <- 0             # Replace missing values with a specific value (e.g., 0)

# Missing values in Data Frames
sum(is.na(df))               # Total number of missing values in dataset
colSums(is.na(df))           # Check missing values in each column
sum(is.na(df$col_name))      # Identify missing values in a specific column
No_missing_df <- na.omit(df) # Remove rows with missing values

# Imputation (Replacing NAs in Dataframes)
df$col_name[is.na(df$col_name)] <- mean(df$col_name, na.rm = TRUE)   # Mean
df$col_name[is.na(df$col_name)] <- median(df$col_name, na.rm = TRUE) # Median
df$col_name[is.na(df$col_name)] <- "Unknown"                         # Categorical

# --- Handling Outliers (IQR Method) ---
Q1 <- quantile(df$col_name, 0.25)
Q3 <- quantile(df$col_name, 0.75)
iqr <- IQR(df$col_name)
lower <- Q1 - 1.5 * iqr
upper <- Q3 + 1.5 * iqr

# Getting outlier values directly
outliers <- boxplot(df$col_name)$out 

# Removing outliers
clean_df <- df[df$col_name >= lower & df$col_name <= upper, ]

# Capping outliers
df$col_name[df$col_name < lower] <- lower
df$col_name[df$col_name > upper] <- upper

# --- Data Integration (Joins & Stacking) ---
# Left Join (keeps all rows from left dataset)
combined_left <- students %>% left_join(academic, by = "student_id")

# Inner Join (keeps only matching rows)
combined_inner <- students %>% inner_join(academic, by = "student_id")

# Stacking rows & columns
stacked_data <- bind_rows(data_1, data_2)     # Vertical (adds rows)
concatenated_data <- bind_cols(data_3, data_4) # Horizontal (adds columns)

# --- Data Transformation ---
# Log transformation for highly skewed data
data_t <- data_t %>% mutate(log_time = log(Time_Minutes))

# Standardization (Z-score: Mean = 0, SD = 1)
data_t <- data_t %>% mutate(z_score = as.numeric(scale(Exam_Score)))


# ==============================================================================
# 2. DATA VISUALIZATION WITH ggplot2
# ==============================================================================
# Basic ggplot2 syntax: ggplot(data, aes(x, y)) + geom_*()

# --- Scatter Plots & Bubble Plots (Numerical vs Numerical) ---
# Simple scatter plot with fixed color and transparency
ggplot(bank_data, aes(x = age, y = duration)) +
  geom_point(color = "#3B82F6", alpha = 0.3) +
  labs(title = "Call duration vs age", x = "Age", y = "Call duration")

# Scatter plot mapped to a categorical variable (color = y)
ggplot(bank_data, aes(x = age, y = duration, color = y)) +
  geom_point(alpha = 0.3) +
  scale_color_manual(values = c("no" = "#60A5FA", "yes" = "#F97316"))

# Bubble Plot (Adding size mapping)
ggplot(bank_data, aes(x = age, y = duration, size = campaign, color = y)) +
  geom_point(alpha = 0.65) +
  scale_size(range = c(2, 10)) # Adjusts bubble size limits

# --- Bar Charts (Categorical Data) ---
# Standard Bar Chart (geom_bar automatically counts occurrences)
ggplot(loan_data, aes(x = Approved)) +
  geom_bar(fill = "#0D9488", color = "white")

# Column Chart (geom_col for pre-calculated counts)
job_counts <- bank_data %>% count(job, sort = TRUE)
ggplot(job_counts, aes(x = reorder(job, -n), y = n)) + # -n for descending sort
  geom_col(fill = "#14B8A6")

# Horizontal Bar Chart (coord_flip)
ggplot(job_counts, aes(x = reorder(job, n), y = n)) + # Ascending sort
  geom_col(fill = "#F97316") +
  coord_flip()

# Stacked Bar Chart
ggplot(bank_data, aes(x = education, fill = y)) +
  geom_bar(color = "white")

# Dodged Bar Chart (Side-by-side)
ggplot(bank_data, aes(x = education, fill = y)) +
  geom_bar(position = "dodge", color = "white")

# 100% Stacked Bar Chart (Proportions)
ggplot(bank_data, aes(x = marital, fill = y)) +
  geom_bar(position = "fill", color = "white") +
  scale_y_continuous(labels = scales::percent_format())

# --- Distributions (Numerical Data) ---
# Histogram (Frequency distribution)
ggplot(bank_data, aes(x = age)) +
  geom_histogram(bins = 30, fill = "#14B8A6", color = "white")

# Density Plot (Smoothed distribution)
ggplot(bank_data, aes(x = age, fill = y)) +
  geom_density(alpha = 0.35)

# Boxplot (Shows median, quartiles, and outliers)
ggplot(bank_data, aes(y = age)) +
  geom_boxplot(fill = "#A7C7E7", width = 0.3)

# Comparative Boxplot
ggplot(bank_data, aes(x = y, y = age, fill = y)) +
  geom_boxplot(alpha = 0.85)

# --- Themes, Labels & Exporting ---
# Formatting titles and axes
p <- ggplot(bank_data, aes(x = age, y = duration)) +
  geom_point() +
  labs(title = "My Plot", x = "Age", y = "Duration") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"), # Center & bold title
    axis.text.x = element_text(angle = 45, hjust = 1)      # Rotate x-axis labels
  )

# Exporting / Saving plots
ggsave(filename = "scatter_plot.png", plot = p, width = 7, height = 5, dpi = 300)


# ==============================================================================
# 3. ADVANCED PLOTS
# ==============================================================================

# --- Map Visualizations ---
world <- map_data('world')
ggplot(world, aes(long, lat, group = group)) +
  geom_polygon(fill = 'lightblue', color = 'black') +
  coord_fixed()

# --- Correlograms (Correlation Matrices) ---
data(mtcars)
cor_matrix = cor(mtcars)

corrplot(cor_matrix, type = "upper", method = "color", 
         addCoef.col = "black", number.cex = 0.6, 
         tl.col = "black", tl.srt = 45)

# --- Heat Maps ---
ggplot(df, aes(x, y, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red")


# ==============================================================================
# 4. INTERACTIVE DASHBOARDS WITH R SHINY
# ==============================================================================

# 1. User Interface (UI) -> What the user sees
ui <- fluidPage(
  titlePanel("My First Shiny Dashboard"),
  
  sidebarLayout(
    # Sidebar for Inputs
    sidebarPanel(
      selectInput("var_x", "Select Variable:", choices = c("mpg", "disp", "hp")),
      sliderInput("bins", "Number of bins:", min = 1, max = 50, value = 30)
    ),
    
    # Main Panel for Outputs (Using Tabs)
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("distPlot")),
        tabPanel("Summary", verbatimTextOutput("summaryData")),
        tabPanel("Data", dataTableOutput("tableData"))
      )
    )
  )
)

# 2. Server Logic -> Calculations and generating plots
server <- function(input, output) {
  
  # Render the plot dynamically
  output$distPlot <- renderPlot({
    x <- mtcars[[input$var_x]] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  # Render text/summary dynamically
  output$summaryData <- renderPrint({
    summary(mtcars[[input$var_x]])
  })
  
  # Render data table
  output$tableData <- renderDataTable({
    mtcars
  })
}

# 3. Launch the Application
shinyApp(ui = ui, server = server)









# =============================================================================
# DA 3003 — Complete R & ggplot2 Reference Script
# Covers: Data Preprocessing, Visualization, Advanced Plots
# =============================================================================

# ── PACKAGES ──────────────────────────────────────────────────────────────────
library(dplyr)
library(ggplot2)
library(maps)
library(corrplot)
library(scales)


# =============================================================================
# PART 1: DATA PREPROCESSING
# =============================================================================

# ── 1. DATA EXPLORATION & PREPARATION ────────────────────────────────────────

df <- read.csv("path_to_file.csv")

head(df)        # View first 6 rows
str(df)         # Check variable types (numeric, integer, character, factor)
summary(df)     # Summary statistics (min, max, mean, missing values)

# Convert numerical codes to categorical factors
df <- df %>%
  mutate(Approved = factor(Approved,
                           levels = c(0, 1),
                           labels = c("Not approved", "Approved")))


# ── 2. HANDLING MISSING DATA (NA) ─────────────────────────────────────────────

# --- Identify missing values ---
is.na(df)                                         # TRUE/FALSE matrix
sum(is.na(df))                                    # Total NAs in dataset
colSums(is.na(df))                                # NAs per column
sum(is.na(df$col_name))                           # NAs in a specific column

# --- Ignore or remove missing values ---
mean(df$col_name, na.rm = TRUE)                   # Ignore NAs in calculation
na.omit(df$col_name)                              # Remove NAs from a vector
as.vector(na.omit(df$col_name))                   # Clean vector without NAs
clean_df <- na.omit(df)                           # Drop ANY row containing NA

# --- Impute (replace) missing values ---
df$col_name[is.na(df$col_name)] <- 0                              # Fixed value
df$col_name[is.na(df$col_name)] <- "Unknown"                      # New category
df$col_name[is.na(df$col_name)] <- mean(df$col_name, na.rm = TRUE)   # Mean
df$col_name[is.na(df$col_name)] <- median(df$col_name, na.rm = TRUE) # Median


# ── 3. IDENTIFYING & HANDLING OUTLIERS (IQR METHOD) ──────────────────────────

# Quick detection via boxplot
outliers <- boxplot(df$column)$out

# Mathematical IQR calculation
Q1    <- quantile(df$column, 0.25)
Q3    <- quantile(df$column, 0.75)
iqr   <- IQR(df$column)
lower <- Q1 - 1.5 * iqr
upper <- Q3 + 1.5 * iqr

# Identify outliers
outliers_alt <- df$column[df$column < lower | df$column > upper]

# Treatment 1: Remove outliers
clean_df <- df[df$column >= lower & df$column <= upper, ]

# Treatment 2: Cap outliers at boundary limits
df_capped <- df
df_capped$column[df_capped$column < lower] <- lower
df_capped$column[df_capped$column > upper] <- upper


# ── 4. DATA INTEGRATION (JOINS & STACKING) ───────────────────────────────────

# Left Join — keep all rows from df1, add matching columns from df2
comb_left  <- df1 %>% left_join(df2, by = "student_id")
# Base R:  merge(df1, df2, by = "student_id", all.x = TRUE)

# Inner Join — keep only rows where IDs match in BOTH datasets
comb_inner <- df1 %>% inner_join(df2, by = "student_id")
# Base R:  merge(df1, df2, by = "student_id")

# Vertical stacking (add rows)
bind_rows(data1, data2)   # dplyr
rbind(data1, data2)       # Base R

# Horizontal stacking (add columns)
bind_cols(data1, data2)   # dplyr
cbind(data1, data2)       # Base R


# ── 5. DATA TRANSFORMATION ───────────────────────────────────────────────────

# Log transformation (right-skewed data)
df$log_val <- log(df$value)

# Standardisation / Z-score  (mean = 0, SD = 1)
df$z_score <- as.numeric(scale(df$value))


# =============================================================================
# PART 2: DATA VISUALIZATION (ggplot2)
# =============================================================================

# ── 1. THE CORE GRAMMAR ───────────────────────────────────────────────────────
#
#  ggplot(data, aes(x, y)) + geom_XXX()
#
#  MAPPED  (inside  aes): changes per data value   → aes(color = Category)
#  FIXED   (outside aes): single style for all     → geom_point(color = "blue")


# ── 2. SCATTER PLOT ───────────────────────────────────────────────────────────

p_scatter <- ggplot(df, aes(x = var1, y = var2)) +
  geom_point(alpha = 0.75, size = 3) +
  labs(title = "Scatter Plot", x = "Variable 1", y = "Variable 2") +
  theme_minimal()


# ── 3. BUBBLE CHART ──────────────────────────────────────────────────────────

p_bubble <- ggplot(df, aes(x = var1, y = var2, size = var3, color = cat_var)) +
  geom_point(alpha = 0.65) +
  scale_size(range = c(2, 10)) +
  labs(title = "Bubble Chart") +
  theme_minimal()


# ── 4. BAR CHART (counts automatically) ──────────────────────────────────────

p_bar <- ggplot(df, aes(x = Category)) +
  geom_bar(fill = "#0D9488", color = "white") +
  labs(title = "Bar Chart", x = "Category", y = "Count") +
  theme_minimal()


# ── 5. COLUMN CHART (plots exact dataset values) ─────────────────────────────

p_col <- ggplot(df, aes(x = Category, y = Value)) +
  geom_col(fill = "#0D9488") +
  labs(title = "Column Chart") +
  theme_minimal()


# ── 6. HISTOGRAM ─────────────────────────────────────────────────────────────

p_hist <- ggplot(df, aes(x = continuous_var)) +
  geom_histogram(bins = 8, fill = "#6366F1", color = "white") +
  labs(title = "Histogram", x = "Value", y = "Frequency") +
  theme_minimal()


# ── 7. DENSITY PLOT ──────────────────────────────────────────────────────────

p_density <- ggplot(df, aes(x = continuous_var, fill = group_var)) +
  geom_density(alpha = 0.25) +
  labs(title = "Density Plot") +
  theme_minimal()


# ── 8. BOX PLOT ──────────────────────────────────────────────────────────────

p_box <- ggplot(df, aes(x = cat_var, y = continuous_var)) +
  geom_boxplot(width = 0.3) +
  labs(title = "Box Plot") +
  theme_minimal()


# ── 9. MODIFYING BAR CHARTS ──────────────────────────────────────────────────

# Sorted bars (descending)
ggplot(df, aes(x = reorder(Category, -Count), y = Count)) +
  geom_col()

# Side-by-side bars
geom_bar(position = "dodge")

# 100% stacked bars
geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format())

# Horizontal bars
geom_col() + coord_flip()


# ── 10. COLORS, SCALES & LABELS ──────────────────────────────────────────────

# Manual color palettes
scale_color_manual(values = c("Not approved" = "#93C5FD", "Approved" = "#F97316"))
scale_fill_manual(values  = c("Male" = "steelblue", "Female" = "tomato"))

# Axis & legend labels
labs(
  title  = "My Plot",
  x      = "X-Axis Label",
  y      = "Y-Axis Label",
  fill   = "Legend Title",   # use color = if you mapped color in aes()
  color  = "Group"
)


# ── 11. THEMES ───────────────────────────────────────────────────────────────

theme_minimal()   # Clean, minimal clutter  ← recommended
theme_classic()   # Axis lines, no grid
theme_bw()        # White background, grey grid

# Fine-grained theme tweaks
theme(
  plot.title    = element_text(hjust = 0.5, face = "bold"), # Centred bold title
  axis.text.x   = element_text(angle = 45, hjust = 1),      # Rotated x labels
  legend.position = "none"                                  # Hide legend
)


# ── 12. SAVING PLOTS ─────────────────────────────────────────────────────────

dir.create("ggplot_outputs", showWarnings = FALSE)

ggsave(
  filename = "ggplot_outputs/my_plot.png",
  plot     = p_scatter,   # Replace with your ggplot object
  width    = 7,
  height   = 5,
  dpi      = 300
)


# =============================================================================
# PART 3: ADVANCED PLOTS
# =============================================================================

# ── 1. MAP VISUALISATION ─────────────────────────────────────────────────────

world <- map_data("world")

p_map <- ggplot(world, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "lightblue", color = "black") +
  coord_fixed() +            # Prevents distortion
  labs(title = "World Map") +
  theme_minimal()


# ── 2. CORRELOGRAM ───────────────────────────────────────────────────────────

cor_matrix <- cor(mtcars)   # Must be numeric columns only

corrplot(
  cor_matrix,
  type         = "upper",   # Show top-half triangle only
  method       = "color",   # Colour intensity = correlation strength
  addCoef.col  = "black",   # Print numeric coefficients
  number.cex   = 0.6,       # Coefficient text size
  tl.col       = "black",   # Variable label colour
  tl.srt       = 45         # Label rotation
)


# ── 3. HEAT MAP ──────────────────────────────────────────────────────────────

p_heat <- ggplot(df, aes(x = col_var, y = row_var, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Heat Map", fill = "Value") +
  theme_minimal()


# =============================================================================
# END OF SCRIPT
# =============================================================================