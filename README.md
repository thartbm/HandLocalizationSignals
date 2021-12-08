# Hand Localization Signals

Project on efferent and afferent signals used to localize where our unseen hand is. Primarily, we ask if afferent (proprioception) and efferent (predicted consequences) signals combine in an optimal way, in the Bayesian / MLE sense. Alternatively, the projects is about if that question can even be answered with the kinds of measurements we have here.

This GitHub repository has code to access, process and analyze data from this OSF repo: [https://osf.io/dhk3u/](https://osf.io/dhk3u/).

The data has been optimized for others to use as well: it is compartmentalized by experimental group (there are 14) and parts of the experiment one might be interested in (there are 3), and all spatial units have been converted to centimeters. Redundant information has been removed to greatly reduce the size of the data set. The data is still in a raw format though, and we provide generic processing functions in a separate GitHub repository, which is also an R package that can be installed and used separately: [https://github.com/thartbm/handlocs](https://github.com/thartbm/handlocs). All project-specific code can be found here though.

# Population Sample

The data set has behavioral measurements from 272 participants doing a visuomotor rotation adaptation task on our InMotion 2 robot. Most participants are undergraduates at York University, but there are a few special populations as well. First, 38 participants are older (50+) participants, split into two groups that each did a different training condition. Then there are 14 people with Ehlers-Danlos Syndrom (EDS) and 16 age-matched controls. There are also 4 groups of people that participated in pilot versions of the experiment, and these have an incomplete data set. All participants (except the EDS and their controls) confirmed they were right handed, have normal or corrected-to-normal vision and gave prior, written, informed consent. Procedures are in line with international standards and have been approved by York's Human Participant Review Committee.

# Experimental data

All of these participants performed the same 4 baseline tasks multiple times. First, they use the robot manipulandum to move a cursor to a target ("training"), they also move to the same targets without visual feedback ("no-cursor reaches"). Most relevant to our main question, the also move out their own hand (holding the manipulandum) and then - without seeing it - localize where they think/feel their hand is ("active localization"), and finally the robot moves out their hand to the same locations, and then they also indicate - again without seeing their - where they think/feel it is ("passive localization"). These last two responses are made by touching a touchscreen, with the index finger on the left hand.

These last two kinds of data are most relevant to our main questions. Presumably when moving your own hand, you have both afferent and efferent information about hand location, while when the robot moves your hand, there is no efferent information about hand location (predicted sensory consequences are only calculated when the brain plans a movement). We will look at the variance of those responses to see if having efferent information makes hand localization more precise.

Then, all groups engaged in visuomotor rotation adaptation where the visual feedback during the "training" trials is rotated around the home position. For most groups this is a rotation of 30 degrees (1 hour on a clock face), but it is 60 degrees for a few of them. Other participants get instructed about the nature of the change of the feedback and are taught a strategy to counter this perturbation ("instructed" groups). Two groups get different visual feedback ("cursorjump" and "handview"). Since the training differs for most groups, we will not use the data from these sessions for our main question, but we will use it for secondary questions.

