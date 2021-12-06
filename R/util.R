# data download code -----

library('osfr')


downloadData <- function(removezips=TRUE, checkfiles=TRUE, folder='data') {
  
  downloadList <- getDownloadList()
  
  #handlocs::downloadOSFdata(repository='',downloadList,folder=folder)
  
  #unzipZips(downloadList,folder=folder,removezips=removezips)
  
  #checkFiles(downloadList,folder=folder)
  
}





getDownloadList <- function(groups='all', data=c('aligned','rotated')) {
  
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
  alldata <- c('aligned','rotated','localization-reaches')
  if ( all(data %in% c('all','a'))) {
    data <- alldata
  } else {
    data <- data[which(data %in% alldata)]
  }
  
  # start vector with demographics file and checklist of files:
  filelist <- c('demographics.csv', 'files.csv')
  # add other files:
  for (group in groups) {
    for (datum in data) {
      filelist <- c(filelist, sprintf('%s_%s.zip',group,datum))
    }
  }
  
  # put it in a list, specifying the folder "data"...
  downloadList <- list()
  downloadList[['data']] <- filelist
  
  return(downloadList)
  
}

