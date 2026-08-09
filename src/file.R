# ==============================================================================
# COMPREHENSIVE R SCRIPT: MISSING DATA ANALYSIS
# Scenario: "HealthyLife Clinical Trial"
# ==============================================================================

# Install required packages if not already installed (uncomment to run)
# install.packages(c("tidyverse", "naniar", "mice", "VIM"))

library(tidyverse)
library(naniar)
library(mice)
library(VIM)

# ------------------------------------------------------------------------------
# 1. CREATE SCENARIO & SIMULATE MISSING DATA MECHANISMS
# ------------------------------------------------------------------------------
set.seed(42) # Set seed for reproducibility

n <- 100 # 100 patients in the trial
health_data <- data.frame(
  patient_id = 1:n,
  age = sample(25:65, n, replace = TRUE),
  gender = sample(c("Male", "Female"), n, replace = TRUE),
  bmi = rnorm(n, mean = 26, sd = 4),
  blood_pressure = rnorm(n, mean = 125, sd = 10)
)

health_incomplete <- health_data

# A) MCAR (Missing Completely At Random):
# A digital blood pressure monitor randomly fails for 15 patients.
mcar_rows <- sample(1:n, 15)
health_incomplete$blood_pressure[mcar_rows] <- NA

# B) MAR (Missing At Random):
# BMI is missing depending on Age. Older patients (>55) missed the BMI station.
mar_rows <- which(health_incomplete$age > 55)
health_incomplete$bmi[mar_rows] <- NA

# C) MNAR (Missing Not At Random):
# People with a very high BMI (> 32) refuse to step on the scale. 
mnar_rows <- which(health_incomplete$bmi > 32)
health_incomplete$bmi[mnar_rows] <- NA


# ------------------------------------------------------------------------------
# 2. DETECTING & VISUALIZING MISSING DATA
# ------------------------------------------------------------------------------
# Total missing values in the dataset
sum(is.na(health_incomplete))

# Missing values by variable
colSums(is.na(health_incomplete))

# Percentage of missing values by variable
round(colMeans(is.na(health_incomplete)) * 100, 1)

# Subsetting Complete vs Incomplete Cases
complete_patients <- health_incomplete %>% filter(complete.cases(.))
incomplete_patients <- health_incomplete %>% filter(!complete.cases(.))

# Visualizing missing patterns
vis_miss(health_incomplete)        # Visual overview of present vs missing
gg_miss_var(health_incomplete)     # Number of missing values per variable
gg_miss_case(health_incomplete)    # Missing values per observation (patient)
md.pattern(health_incomplete)      # Missing data pattern matrix


# ------------------------------------------------------------------------------
# 3. DELETION METHODS
# ------------------------------------------------------------------------------
# A) Complete-Case Analysis (Listwise Deletion)
health_cc <- na.omit(health_incomplete)
dim(health_incomplete) # Original rows/cols
dim(health_cc)         # Rows/cols after listwise deletion
summary(health_incomplete$bmi) 
summary(health_cc$bmi)

# B) Available-Case Analysis (Pairwise Deletion)
# Calculates mean using whatever data is available for that specific variable
mean_bmi_avail <- mean(health_incomplete$bmi, na.rm = TRUE)
mean_bp_avail <- mean(health_incomplete$blood_pressure, na.rm = TRUE)

# Correlation between Age and Blood Pressure using pairwise complete cases
cor(health_incomplete$age, health_incomplete$blood_pressure, use = "pairwise.complete.obs")


# ------------------------------------------------------------------------------
# 4. SINGLE IMPUTATION METHODS
# ------------------------------------------------------------------------------

# A) Mean Imputation (Blood Pressure)
health_mean <- health_incomplete
mean_bp <- mean(health_mean$blood_pressure, na.rm = TRUE)
health_mean$blood_pressure[is.na(health_mean$blood_pressure)] <- mean_bp
var(health_incomplete$blood_pressure, na.rm = TRUE) # Variance before
var(health_mean$blood_pressure)                     # Variance after (shrinks)

# B) Median Imputation (BMI)
health_median <- health_incomplete
median_bmi <- median(health_median$bmi, na.rm = TRUE)
health_median$bmi[is.na(health_median$bmi)] <- median_bmi

# C) Deterministic Regression Imputation (Predict BMI from Age)
health_det_reg <- health_incomplete
fit_det <- lm(bmi ~ age, data = health_det_reg, na.action = na.omit)
missing_bmi_idx <- is.na(health_det_reg$bmi)

predicted_bmi_det <- predict(fit_det, newdata = health_det_reg[missing_bmi_idx, ])
health_det_reg$bmi[missing_bmi_idx] <- predicted_bmi_det

# D) Stochastic Regression Imputation (Predict BMI from Age + Random Noise)
health_stoch_reg <- health_incomplete
fit_stoch <- lm(bmi ~ age, data = health_stoch_reg, na.action = na.omit)
missing_bmi_idx2 <- is.na(health_stoch_reg$bmi)

# Predict for all, then calculate the residual standard deviation (sigma)
predicted_all <- predict(fit_stoch, newdata = health_stoch_reg)
resid_sd <- summary(fit_stoch)$sigma

# Generate random noise for missing rows
set.seed(123)
noise <- rnorm(sum(missing_bmi_idx2), mean = 0, sd = resid_sd)
health_stoch_reg$bmi[missing_bmi_idx2] <- predicted_all[missing_bmi_idx2] + noise

# Compare Variance (Stochastic preserves variance much better than deterministic)
c(Observed_var = var(health_incomplete$bmi, na.rm = TRUE),
  Deterministic_var = var(health_det_reg$bmi),
  Stochastic_var = var(health_stoch_reg$bmi))

# E) Hot-Deck Imputation (Impute BP using Age as the ordering/matching variable)
set.seed(123)
health_hotdeck <- hotdeck(
  health_incomplete,
  variable = "blood_pressure",
  ord_var = "age",
  imp_var = TRUE
)
table(health_hotdeck$blood_pressure_imp) # Check count of imputed values


# ------------------------------------------------------------------------------
# 5. LONGITUDINAL PATTERNS: LAST OBSERVATION CARRIED FORWARD (LOCF)
# ------------------------------------------------------------------------------
# Creating a subset of longitudinal data (Monotone pattern due to patient dropout)
longitudinal_data <- data.frame(
  patient = rep(c("P001", "P002", "P003"), each = 4),
  visit = rep(c("Baseline", "Month_3", "Month_6", "Month_12"), 3),
  weight = c(85, 83, 81, 79,   # Patient 1 completes all visits
             92, 90, NA, NA,   # Patient 2 drops out after month 3
             74, NA, NA, NA)   # Patient 3 drops out after baseline
)

# Apply LOCF (group by patient, fill missing values downwards)
longitudinal_locf <- longitudinal_data %>%
  group_by(patient) %>%
  fill(weight, .direction = "down") %>%
  ungroup()

print(longitudinal_locf)
