# packages
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


# Packages ----------------------------------------------------------------
# when loading opackage then need to call library so have access to all
# put at start of script


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
