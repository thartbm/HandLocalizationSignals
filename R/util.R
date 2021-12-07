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
downloadData <- function(folder='data', removezips=TRUE, checkfiles=TRUE, groups='all', sections=c('aligned','rotated')) {
  
  filelist <- getDownloadList(groups=groups,sections=sections)
  
  #handlocs::downloadOSFdata(repository='https://osf.io/dhk3u/',filelist,folder=folder)
  
  #unzipZips(filelist,folder=folder,removezips=removezips)
  
  #checkFiles(filelist,folder=folder)
  
  
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
      filelist <- c(filelist, sprintf('%s_%s.zip',group,sections))
    }
  }
  
  # put it in a list, specifying the folder "data"...
  downloadList <- list()
  downloadList[['data']] <- filelist
  
  return(downloadList)
  
}

