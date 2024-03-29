#' Filenames for the full data set
#'
#' List of all existing files in the data set. There can be a maximum of 12 specific files for each participant (see below).
#' If a cell is empty, that file is missing for the participant.
#' The rotated data for the 70 participants in the \code{'org_*'} groups is not included and the localization reach data for 
#' participant \code{'37dfa7'} in the EDSmatch group is missing.
#'
#' @format A data frame with 272 rows (participants) and 15 variables:
#' \describe{
#'   \item{group}{one of 14 groups, see detailes below}
#'   \item{participant}{one of 272 participants: a random, 6-character identifier, used in filenames as well}
#'   \item{strategy_order}{order of include and exclude strategy no-cursor blocks, empty for 'org_*' groups}
#'   \item{aligned_training}{}
#'   \item{aligned_nocursor}{}
#'   \item{aligned_activelocalization}{}
#'   \item{aligned_passivelocalization}{}
#'   \item{aligned_activereach}{}
#'   \item{aligned_passivereach}{}
#'   \item{rotated_training}{}
#'   \item{rotated_nocursor}{}
#'   \item{rotated_activelocalization}{}
#'   \item{rotated_passivelocalization}{}
#'   \item{rotated_activereach}{}
#'   \item{rotated_passivereach}{}
#' }
#'@details
#'
#' There are 14 groups of participant, who mostly differ on the instructions or task in the rotated session,
#' but all did the same aligned session. The primary results are published here:
#' 
#' From \href{https://doi.org/10.1371/journal.pone.0220884}{Modchalingam et al. (2018)}:
#' 
#' \itemize{
#'   \item \code{'control'}: 20 younger participants, 30 degree rotation, no strategy instruction, normal feedback
#'   \item \code{'control60'}: 20 younger participants, 60 degree rotation, no strategy instruction, normal feedback
#'   \item \code{'instructed'}: 21 younger participants, 30 degree rotation, detailed strategy, normal feedback 
#'   \item \code{'instructed60'}: 24 younger participants, 60 degree rotation, detailed strategy, normal feedback
#' }
#' 
#' From \href{https://doi.org/10.1371/journal.pone.0239032}{Vachon et al. (2020)}:
#' 
#' \itemize{
#'   \item \code{'older_control'}: 19 older participants, 30 degree rotation, no strategy instruction, normal feedback
#'   \item \code{'older_instructed'}: 19 older participants, 30 degree rotation, detailed strategy, normal feedback
#' }
#' 
#' From \href{https://doi.org/10.1038/s41598-020-76940-3}{Gastrock et al. (2020)}:
#' 
#' \itemize{
#'   \item \code{'cursorjump'}: 20 younger participants, 30 degree rotation, no strategy instruction, cursor-jump feedback
#'   \item \code{'handview'}: 29 younger participants, 30 degree rotation, no strategy instruction, hand visible during training
#' }
#' 
#' From \href{https://doi.org/10.1080/08990220.2021.1973403}{Clayton et al. (2021)}:
#' 
#' \itemize{
#'   \item \code{'EDS'}: 14 younger participants, 30 degree rotation, no strategy instruction, normal feedback
#'   \item \code{'EDSmatched'}: 16 younger participants, 30 degree rotation, no strategy instruction, normal feedback
#' }
#' 
#' This paper is also available as a {https://doi.org/10.1101/2021.04.09.439251}{preprint}.
#' 
#' From piloting studies:
#' 
#' \itemize{
#'   \item \code{'org_control'}: 16 participants, pilot version of \code{'control'}
#'   \item \code{'org_instructed'}: 17 participants, pilot version of \code{'instructed'}
#'   \item \code{'org_control60'}: 18 participants, pilot version of \code{'control60'}
#'   \item \code{'org_instructed60'}: 19 participants, pilot version of \code{'instructed60'}
#' }
#' 
#' For each group the data is split into 3 sections, corresponding to a zipfile that can be downloaded from OSF, except
#' for the \code{'org_*'} groups which only have 2 sections or zipfiles. Each of these sections or zipfiles have subfolders 
#' for each participant and would provide at maximum 4 files per participant.
#' 
#' Here are the 3 sections each with the 4 kind of files they provide:
#' 
#' \enumerate{
#'   \item{\code{'aligned'}:} data from the aligned session \enumerate{
#'     \item{\code{'aligned_training'}:} {training reaches}
#'     \item{\code{'aligned_nocursor'}:} {no-cursor reaches}
#'     \item{\code{'aligned_activelocalization'}:} {active localization responses}
#'     \item{\code{'aligned_passivelocalization'}:} {passive localization responses}
#'   }
#'   \item{\code{'rotated'}:} data from the rotated session (not for the 'org_*' groups) \enumerate{
#'     \item{\code{'rotated_training'}:} {training reaches}
#'     \item{\code{'rotated_nocursor'}:} {no-cursor reaches}
#'     \item{\code{'rotated_activelocalization'}:} {active localization responses}
#'     \item{\code{'rotated_passivelocalization'}:} {passive localization responses}
#'   }
#'   \item{\code{'localization-reaches'}:} reach trajectories from the localization tasks \enumerate{
#'     \item{\code{'aligned_activereach'}:} {aligned, active localization}
#'     \item{\code{'aligned_passivereach'}:} {aligned, passive localization}
#'     \item{\code{'rotated_activereach'}:} {rotated, active localization}
#'     \item{\code{'rotated_passivereach'}:} {rotated, passive localization}
#'   }
#' }
#' 
#' The 3 main items in the enumeration above are the exact names of the 3 section. The 12 sub-items
#' provide the exact names of the last 12 columns in the \code{'files'} data frame.
#' 
#' After running the function to fetch data from OSF, there should be \code{'[group]_[section].zip'} files in your
#' data folder. There should also be a subfolder for each group, which has a subfolder for each participant, with
#' all files for the participant.
#' 
#' Run \code{\link{downloadData}} to download the data.
#' 
"files"