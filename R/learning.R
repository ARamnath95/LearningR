# Packages ----------------------------------------------------------------
# when loading a package then need to call library so have access to all
# put at start of script
library(tidyverse)
library(NHANES)

10
# cntrl shft p for new section
# R basics ----------------------------------------------------------------
# shrtcut for <- is optn -
weight_kilos <- 100
weight_kilos <- 10

weight_kilos
# autocompletion tools
# cmd entr to send to consol
colnames(airquality)

str(airquality)

summary(airquality)

# making code more readable
# code reformat code or cntrl shft a will restyle
2 + 2
# cmd shft p then stle activel file
2 + 2

# This will be used for testing out Git.


# Looking at data ---------------------------------------------------------

glimpse(NHANES)
colnames(NHANES)
# first object is always the dataset.
select(NHANES, Age, Weight, BMI)
select(NHANES, -HeadCirc)
select(NHANES, starts_with("BP"))
select(NHANES, ends_with("Day"))
select(NHANES, contains("Age"))

nhanes_small <- select(
  NHANES,
  Age,
  Gender,
  BMI,
  Diabetes,
  PhysActive,
  BPSysAve,
  BPDiaAve,
  Education
)

# Fixing variable names ---------------------------------------------------

nhanes_small <- rename_with(
  nhanes_small,
  snakecase::to_snake_case
)

nhanes_small <- rename(
  nhanes_small,
  sex = gender
)

nhanes_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)

nhanes_small


# Piping  -----------------------------------------------------------------

colnames(nhanes_small)

nhanes_small %>%
  colnames()
nhanes_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)


# Exercise 7.8 ------------------------------------------------------------

nhanes_small %>%
  select(bp_sys_ave, bp_dia_ave, education) %>%
  rename(bp_sys = bp_sys_ave) %>%
  rename(bp_dia = bp_dia_ave) %>%
  nhanes_small() %>%
  select(bmi, contains("age"))

nhanes_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)


# Filtering rows ----------------------------------------------------------

nhanes_small %>%
  filter(phys_active != "No")

nhanes_small %>%
  filter(
    bmi >= 25,
    phys_active == "No"
  )

nhanes_small %>%
  filter(bmi == 25 |
    phys_active == "No")


# Arranging rows ----------------------------------------------------------

nhanes_small %>%
  arrange(desc(age), bmi, education)


# Mutating columns --------------------------------------------------------
# works consequentially, so weeks can be calculated after months have been calculated.
nhanes_update <- nhanes_small %>%
  mutate(
    age_months = age * 12,
    logged_bmi = log(bmi),
    age_weeks = age_months * 4,
    old = if_else(
      age >= 30,
      "old",
      "young"
    )
  )

nhanes_update


# Exercise 7.12 -----------------------------------------------------------

# 1. BMI between 20 and 40 with diabetes
nhanes_small %>%
  # Format should follow: variable >= number or character
  filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# Pipe the data into mutate function and:
nhanes_modified <- nhanes_small %>% # Specifying dataset
  mutate(
    # 2. Calculate mean arterial pressure
    mean_arterial_pressure = (((bp_dia_ave * 2) + bp_sys_ave) / 3),
    # 3. Create young_child variable using a condition
    young_child = if_else(
      age < 6,
      "Yes",
      "No"
    )
  )

nhanes_modified

# Summarising -------------------------------------------------------------
# will only give 1 row unless grouped based on data from a specific column, eg yes no or NA diabetes groups, where as mutate gives the whole table.
nhanes_small %>%
  filter(!is.na(diabetes)) %>%
  group_by(
    diabetes,
    phys_active
  ) %>%
  summarise(
    max_bmi = max(bmi,
      na.rm = TRUE
    ),
    min_bmi = min(bmi,
      na.rm = TRUE
    )
  ) %>%
    ungroup()
#check ungrouping
#nhanes_small
#always end with ungroup so that it doesn't mess up downstream analysis

#here::here tells R where to save file, go to this proj root and look for "data" folder
write_csv(
    nhanes_small,
    here::here("data/nhanes_small.csv")
)
