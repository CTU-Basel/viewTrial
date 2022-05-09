#' To generate visit data using randomization data
#'
#' @param df 
#'
#' @return
#' @export
#'
#' @examples
get_visits <- function(df){
  
  ## Visits
  visits <- df %>%  
    mutate(FU1.date = case_when(FU1 == TRUE ~ rando_date.date + 6*30),
           FU2.date = case_when(FU2 == TRUE ~ rando_date.date + 12*30)) %>% 
    mutate(FU1.qol.done = case_when(FU1 == FALSE ~ NA, TRUE ~ FU1.qol.done),
           FU2.qol.done = case_when(FU2 == FALSE ~ NA, TRUE ~ FU2.qol.done),
           bl.qol.compl = case_when(bl.qol.done == FALSE ~ NA, TRUE ~ bl.qol.compl),
           FU1.qol.compl = case_when(FU1.qol.done == FALSE ~ NA, TRUE ~ FU1.qol.compl),
           FU2.qol.compl = case_when(FU2.qol.done == FALSE ~ NA, TRUE ~ FU2.qol.compl)) 
  
  dates.visits <- visits %>% 
    select(pat_id, centre.short, Baseline = rando_date.date, FU1 = FU1.date, FU2 = FU2.date) %>% 
    ## Gather data
    pivot_longer(cols = c(Baseline, FU1, FU2),
                 names_to = c("Visit"),
                 values_to = c("Date")) 
  qol.done <- visits %>% 
    select(pat_id, centre.short, Baseline = bl.qol.done, FU1 = FU1.qol.done, FU2 = FU2.qol.done) %>% 
    ## Gather data
    pivot_longer(cols = c(Baseline, FU1, FU2),
                 names_to = c("Visit"),
                 values_to = c("qol.done")) 
  
  qol.compl <- visits %>% 
    select(pat_id, centre.short, Baseline = bl.qol.compl, FU1 = FU1.qol.compl, FU2 = FU2.qol.compl) %>% 
    ## Gather data
    pivot_longer(cols = c(Baseline, FU1, FU2),
                 names_to = c("Visit"),
                 values_to = c("qol.compl")) 
  
  nr.visits <- dates.visits %>%   
    filter(!is.na(Date)) %>% 
    group_by(centre.short, Visit) %>% 
    count() %>% 
    rename(nr.visits.done = n)
  
  nr.qol <- qol.done %>% 
    filter(qol.done == TRUE) %>% 
    group_by(centre.short, Visit) %>% 
    count() %>% 
    rename(nr.qol.done = n)
  
  nr.qol.compl <- qol.compl %>% 
    filter(qol.compl == TRUE) %>% 
    group_by(centre.short, Visit) %>% 
    count() %>% 
    rename(nr.qol.compl = n)
  
  visits <- dates.visits %>% 
    left_join(qol.done, by = c("centre.short", "Visit","pat_id")) %>% 
    left_join(qol.compl, by = c("centre.short", "Visit","pat_id")) %>% 
    left_join(nr.visits, by = c("centre.short","Visit")) %>% 
    left_join(nr.qol, by = c("centre.short","Visit")) %>% 
    left_join(nr.qol.compl, by = c("centre.short","Visit")) 
  
  return(visits)
  
}


get_qol_time <- function(df){
  
  df %<>% distinct(centre.short, Visit, .keep_all = TRUE) %>% 
    select(centre.short, Visit) %>% 
    mutate(mean.first.entry = sample(c(1:25), 15, replace = TRUE),
           mean.compl.entry = sample(c(5:50), 15, replace = TRUE),
           centre.short = factor(centre.short, levels = c("A", "B", "C", "D", "E"))) 
  
  return(df)
  
}

get_queries <- function(index, df){
  
  nr <- nrow(df)
  
  new.df <- df %>% 
    select(pat_id, centre.short, Visit) %>% 
    mutate(nr.queries = sample(1:40, nr, replace = TRUE)) %>% 
    slice(index)
  nr.times <- new.df %>% pull(nr.queries)
  result <- new.df %>% slice(rep(1:n(), nr.times))
  
  return(result)
}

get_sae <- function(index, df){
  
  nr <- nrow(df)
  
  new.df <- df %>% 
    select(pat_id, centre.short, Visit) %>% 
    mutate(nr.sae = sample(0:2, nr, replace = TRUE, prob = c(0.8,0.15, 0.05))) %>% 
    slice(index)
  nr.times <- new.df %>% pull(nr.sae)
  result <- new.df %>% slice(rep(1:n(), nr.times))
  
  return(result)
}

#' Load data
#'
#' @return
#' @export
#'
get_data <- function(){
  #######################################################################################################################
  ###                                                     LIBRARIES                                                   ###
  #######################################################################################################################
  library(secuTrialR)
  library(dplyr)
  library(magrittr)
  library(stringr)
  library(tidyr)
  library(lubridate)
  library(janitor)
  library(tables)
  library(ggpubr)
  library(purrr)
  library(DT)

  #######################################################################################################################
  ###                                                     LOAD DATA                                                   ###
  #######################################################################################################################

  data.extraction.date <- Sys.Date()
  
  set.seed(12481498)
  ## Required vars: centre.short, rando_date.date
  randomized <- data.frame(pat_id = sample(c(1:100), 100),
                           centre.short = sample(c("A", "B", "C", "D", "E"), 100, replace = TRUE),
                           rando_date.date = sample(seq(as.Date('2017/12/01'), as.Date('2022/03/01'), by="day"), 100),
                           ended.study = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.95,0.05)),
                           bl.qol.done = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.7,0.3)),
                           bl.qol.compl = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.6,0.4)),
                           FU1 = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.7,0.3)),
                           FU1.qol.done = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.6,0.4)),
                           FU1.qol.compl = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.6,0.4)),
                           FU2 = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.6,0.4)),
                           FU2.qol.done = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.55,0.45)),
                           FU2.qol.compl = sample(c(FALSE, TRUE), 100, replace = TRUE, prob = c(0.45,0.55))) %>%
    mutate(ended.study.reason = case_when(ended.study == TRUE & pat_id %in% c(40, 11, 35) ~ "Death",
                                          ended.study == TRUE & pat_id %in% c(48) ~ "Consent withdrawn",
                                          ended.study == TRUE & pat_id %in% c(24) ~ "Adverse event",
                                          ended.study == TRUE & pat_id %in% c(36) ~ "Switched hospital")) %>%
    ## Get total counts
    group_by(centre.short) %>% mutate(total.ended = sum(ended.study == TRUE), total.randomized = n()) %>% ungroup()
  
  ## Get visit info
  visits <- get_visits(randomized)
  
  ## Get QOL info
  data.qol.time <- get_qol_time(visits)

  ## Merge all info
  df.all <- visits %<>% 
    left_join(randomized %>% select(pat_id, rando_date.date, total.ended, total.randomized, ended.study, ended.study.reason), by = "pat_id") %>% 
    left_join(data.qol.time, by = c("centre.short", "Visit")) %>% 
    mutate(centre.short = factor(centre.short, levels = c("A", "B", "C", "D", "E"))) 
  
  #######################################################################################################################
  ###                                                     SAVE DATA                                                   ###
  #######################################################################################################################

  data <- list(
    data.extraction.date = data.extraction.date
    , randomized = randomized
    , all = df.all
  )

  return(data)
}


