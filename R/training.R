
getReachDeviations <- function(session='aligned', task='training', groups=NULL, at=NULL) {
  
  # get samples where maxvelocity == 1
  # separate by target, rotate so that target is at 0
  # get the angular deviation from 0 at the X,Y coordinates
  
  # return overall, per target, per subtask
  
  df <- read.csv('data/files.csv', stringsAsFactors = F)
  
  if (is.null(groups)) {
    participants <- df$participant[! df$group %in% c('older_control','older_instructed','EDS')]
  } else {
    participants <- df$participant[df$group %in% groups]
  }
  
  all_deviations <- NA
  
  for (pp in participants) {
    
    deviations <- getParticipantReachDeviations( pp      = pp,
                                                 session = session,
                                                 task    = task,
                                                 at      = at        )
    deviations$participant <- pp
    
    if (is.data.frame(all_deviations)) {
      all_deviations <- rbind(all_deviations, deviations)
    } else {
      all_deviations <- deviations
    }
    
  }
  
  return(all_deviations)
  
}

getParticipantReachDeviations <- function(pp, session='aligned', task='training', at=NULL) {
  
  df <- read.csv('data/files.csv', stringsAsFactors = F)
  
  p.idx <- which(df$participant == pp)
  
  col.name <- sprintf('%s_%s', session, task)
  
  filename <- df[p.idx,col.name]
  reaches <- read.csv(sprintf('data/%s/%s/%s',df$group[p.idx],pp,filename), stringsAsFactors = FALSE)
  
  if (task == 'training') {
    if (is.null(at)) { at <- 'maxvelocity' }
    # select only the max-vel samples from the selected trials:
    if (at == 'maxvelocity') {
      reaches <- reaches[which(reaches$trialselected == 1 & reaches$maxvelocity == 1),]
    }
  }
  if (task == 'nocursor') {
    if (is.null(at)) { at <- 'endpoint' }
    # select only the endpoint samples from the selected trials:
    if (at == 'endpoint') {
      reaches <- addEndPointColumn(reaches)
      reaches <- reaches[which(reaches$trialselected == 1 & reaches$endpoint == 1),]
    } else if (at == 'maxvelocity') {
      reaches <- reaches[which(reaches$trialselected == 1 & reaches$maxvelocity == 1),]
    }
  }
  
  # for more advanced processing (later on?) we add subtask number as well:
  reaches <- addSubTaskNumber(df=reaches, session=session)
  
  # empty column for reach deviations:
  reaches$deviation_deg <- NA
  
  for (target in unique(reaches$targetangle_deg)) {
    
    target.idx <- which(reaches$targetangle_deg == target)
    
    coords <- Reach::rotateCoordinates(df    = reaches[target.idx,c('handx_cm','handy_cm')],
                                       angle = -1 * target)
    
    reaches$deviation_deg[target.idx] <- ( atan2(coords$handy_cm, coords$handx_cm) / pi )*180
    
  }
  
  return(reaches)
   
}

getReachSD <- function(hwin=45) {
  
  training    <- getReachDeviations(task='training', session='aligned')
  nocursor_ep <- getReachDeviations(task='nocursor', session='aligned')
  nocursor_mv <- getReachDeviations(task='nocursor', session='aligned', at='maxvelocity')
  
  training    <- training[which(abs(training$deviation_deg)    < hwin),]
  nocursor_ep <- nocursor[which(abs(nocursor_ep$deviation_deg) < hwin),]
  nocursor_mv <- nocursor[which(abs(nocursor_mv$deviation_deg) < hwin),]
  
  training    <- aggregate(deviation_deg ~ participant, data=training,    FUN=sd)
  nocursor_ep <- aggregate(deviation_deg ~ participant, data=nocursor_ep, FUN=sd)
  nocursor_mv <- aggregate(deviation_deg ~ participant, data=nocursor_mv, FUN=sd)
  
  names(training)    <- c('participant', 'training')
  names(nocursor_ep) <- c('participant', 'nocursor_ep')
  names(nocursor_mv) <- c('participant', 'nocursor_mv')
  
  reach_sd <- merge(x = training,
                    y = nocursor_ep, 
                    by = 'participant')
  reach_sd <- merge(x = reach_sd,
                    y = nocursor_mv, 
                    by = 'participant')
  
  return(reach_sd)
  
}

getAdaptation <- function(hwin=45, do_baseline=TRUE) {
  # reference groups, can be used:
  # 'control', 'instructed'
  
  # 60 degree rotations: not very useful...
  # 'control60', 'instructed60'
  
  # external attribution groups, cursorjump could make sense here, handview not so much
  # 'cursorjump', 'handview', 
  
  # older participants are there for different questions... although maybe we CAN include them, if they are not different from others?
  # 'older_control', 'older_instructed'
  
  # EDSmatch seems fine, not sure about the EDS group itself
  # 'EDS', 'EDSmatch', 
  
  # no adaptation data is available for the org groups...
  # 'org_control', 'org_instructed', 'org_control60', 'org_instructed60'
  
  groups <- c('control', 'instructed', 'cursorjump', 'EDSmatch')
  
  #
  #
  #
  
  # now we get the actual adaptation for each of the four groups:
  adaptation <- getReachDeviations(task='training', session='rotated', groups=groups)
  
  # we only want the first adaptation task
  adaptation <- adaptation[which(adaptation$subtask == 25),]
  
  # we remove reach deviations that are out of scope
  adaptation <- adaptation[which(adaptation$deviation_deg > (-1*hwin)),]
  adaptation <- adaptation[which(adaptation$deviation_deg < (30+hwin)),]
  
  #
  # what is going on?
  #
  
  # now we baseline, and we can only do this for people who *have* a baseline:
  # might be all of them, I'm not even going to check that
  adaptation <- adaptation[which(adaptation$participant %in% unique(baseline$participant)),]
  
  
  if (do_baseline) {
    
    # we do want to baseline the adaptation:
    baseline <- getReachDeviations(task='training', session='aligned', groups=groups)
    
    # based on the last 30 trials of the first reaching task:
    baseline <- baseline[which(baseline$subtask == 1 & baseline$trial_num > 30),]
    
    # where reaches are reasonable:
    baseline <- baseline[which(abs(baseline$deviation_deg) < hwin),]
    
    # and we use the median for each target:
    baseline <- aggregate(deviation_deg ~ participant * targetangle_deg, data=baseline, FUN=median)
    
    
    for (base.idx in c(1:dim(baseline)[1])) {
      
      pp <- baseline$participant[base.idx]
      target <- baseline$targetangle_deg[base.idx]
      
      adapt.idx <- which(adaptation$participant == pp & adaptation$targetangle_deg == target)
      
      adaptation$deviation_deg[adapt.idx] <- adaptation$deviation_deg[adapt.idx] - baseline$deviation_deg[base.idx]
      
    }
    
  }
  
  return(adaptation)
  
}