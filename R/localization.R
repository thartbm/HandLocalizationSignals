
# this is for aligned only
# excluded groups:
# - older participants (control & instructed)
# - EDS patients

getLocalizationSDs <- function(session='aligned', groups=NULL) {
  
  df <- read.csv('data/files.csv', stringsAsFactors = F)
  
  if (is.null(groups)) {
    participants <- df$participant[! df$group %in% c('older_control','older_instructed','EDS')]
  } else {
    participants <- df$participant[df$group %in% groups]
  }
  
  participant <- c()
  active_sd <- c()
  passive_sd <- c()
  
  for (ppno in participants) {
    
    #cat(sprintf('%s\n',ppno))
    
    p.idx <- which(df$participant == ppno)
    
    act.col.name <- sprintf('%s_activelocalization', session)
    pas.col.name <- sprintf('%s_passivelocalization', session)
    
    files <- list()
    files[['active']]  <- df[p.idx,act.col.name]
    files[['passive']] <- df[p.idx,pas.col.name]
    
    # we need both data sets:
    if (any(names(files) == '')) {
      next()
    }
    
    sds <- list()
    
    for (condition in names(files)) {
      
      filename <- files[[condition]]
      
      locdf <- read.csv(sprintf('data/%s/%s/%s',df$group[p.idx],ppno,filename), stringsAsFactors = FALSE)
      
      locdf <- Reach::circleCorrect(locdf, r=12)
      
      # we only accept reaches that are within 40 degrees on either sdide of the arc
      # this spans 60 degrees, so the range extends 10 degrees beyond that on either side
      # it also has to be within 
      l.idx <- which(abs(locdf$targetangle_deg - locdf$arcangle_deg) < 40 & 
                     abs(sqrt(locdf$handx_cm^2 + locdf$handy_cm^2) - 12) < 5 &
                     locdf$selected == 1)
      
      locdf <- locdf[l.idx,]
      
      # we set the minimum number of trials to 40
      # (out of 72 max, for EACH condition)
      if (dim(locdf)[1] <= 42) {
        next()
      }
      
      locsd <- Reach::localizationSD(df=locdf, CC=TRUE, handvar='hand', locvar='tap', unit='cm', r=12, rm.Extr=TRUE, spar=0.95)
      
      sds[[condition]] <- locsd
      
    }
    
    if (length(sds) == 2) {
      active_sd  <- c(active_sd,  sds[['active']])
      passive_sd <- c(passive_sd, sds[['passive']])
      participant <- c(participant, ppno)
    }
    
  }
  
  return(data.frame(participant, active_sd, passive_sd))
  
}