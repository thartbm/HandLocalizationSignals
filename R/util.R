# data download code -----

#' @title Download project data from OSF repository.
#' @param folder Directory on the working directory to store the downloaded data.
#' @param removezips (Boolean) Remove downloaded zipfiles after unzipping.
#' @param checkfiles (Boolean) Check if all files are there after unzipping.
#' @param groups Vector of groups to download data for ('all' for all groups).
#' Possible values: 'control', 'instructed', 'control60', 'instructed60',
#' 'cursorjump', 'handview', 'older_control', 'older_instructed'
#' 'EDS', 'EDSmatch', 'org_control', 'org_instructed', 'org_control60', and
#' 'org_instructed60'. The last 4 groups are incomplete pilot studies.
#' Default: 'all'.
#' @param sections Vector of sections of data to download for each of the groups
#' ('all' for all sections). Possible values: 'aligned', 'rotated', and
#' 'localization-reaches'. Default: c('aligned', 'rotated')
#' @return Nothing
#' @description Use this function to download the data for the project from the
#' OSF repository: https://osf.io/dhk3u/
#' @details Not yet.
#' @export
downloadData <- function(folder='data', unzip=TRUE, removezips=TRUE, checkfiles=TRUE, groups='all', sections=c('aligned','rotated'), overwrite=TRUE) {
  
  filelist <- getDownloadList(groups=groups,
                              sections=sections)
  
  Reach::downloadOSFdata(repository='https://osf.io/dhk3u/',
                         filelist=filelist,
                         folder=folder,
                         overwrite=overwrite,
                         unzip=unzip,
                         removezips=removezips)
  
  #checkFiles(filelist,folder=folder)
  # implement? (should check if all expected files are there or not)
  # not for now...
  
}



getDownloadList <- function(groups='all', sections=c('aligned','rotated')) {
  
  # these are the possible groups:
  allgroups <- c('control','instructed',
                 'control60','instructed60',
                 'cursorjump','handview',
                 'older_control','older_instructed',
                 'EDS','EDSmatch',
                 'org_control','org_instructed',
                 'org_control60','org_instructed60')
  # remove requested groups that don't exist:
  if ( all(groups %in% c('all','a')) ) {
    groups <- allgroups
  } else {
    groups <- groups[which(groups %in% allgroups)]
  }
  
  # remove requested data that doesn't exist:
  allsections<- c('aligned','rotated','localization-reaches')
  if ( all(sections %in% c('all','a'))) {
    sections <- allsections
  } else {
    sections <- sections[which(sections %in% allsections)]
  }
  
  # start vector with demographics file and checklist of files:
  filelist <- c('demographics.csv', 'files.csv')
  # add other files:
  for (group in groups) {
    for (section in sections) {
      if (substr(group,1,4)=='org_' & section =='rotated') {
        # do nothing: there is no rotated data for these groups
      } else {
        filelist <- c(filelist, sprintf('%s_%s.zip',group,section))
      }
    }
  }
  
  # put it in a list, specifying the folder "data"...
  downloadList <- list()
  downloadList[['data']] <- filelist
  
  return(downloadList)
  
}

addSubTaskNumber <- function(df, session) {
  
  trial2subtask <- c()
  
  # aligned session
  if (session == 'aligned') {
    subtasklengths <- c(45,18,9,18,9,9) # first aligned iteration
    for (repetition in c(1:3)) {
      subtasklengths <- c(subtasklengths, c(9,18,9,18,9,9)) # next 3 iterations:
    }
    offset <- 0
  }
  # rotated session
  if (session == 'rotated') {
    subtasklengths <- c(90,18,30,18,30,9,9) # first aligned iteration
    for (repetition in c(1:3)) {
      subtasklengths <- c(subtasklengths, c(30,18,30,18,30,9,9)) # next 3 iterations:
    }
    offset <- 24
  }
  
  # make a vector where index is trial number (within session, starts at 1 for both the aligned and the rotated)
  # and the values are subtask numbers (across aligned and rotated sessions, starts at 1 and 25 for aligned and rotated respectively)
  for (subtask_idx in c(1:length(subtasklengths))) {
    trial2subtask <- c(trial2subtask, rep(subtask_idx+offset, subtasklengths[subtask_idx]))
  }
  
  # add new subtask column to the data frame:
  df$subtask <- trial2subtask[df$trial_num]
  
  # return the extended data frame:
  return(df)
  
}

addEndPointColumn <- function(df) {
  
  trial_max_time <- aggregate(time_ms ~ trial_num, data=df, FUN=max)
  
  df$endpoint <- 0
  
  for (idx in c(1:dim(trial_max_time)[1])) {
    
    df$endpoint[which(df$time_ms   == trial_max_time$time_ms[idx] &
                      df$trial_num == trial_max_time$trial_num[idx])] <- 1
    
  }
  
  return(df)
  
}