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