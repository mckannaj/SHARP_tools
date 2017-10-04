





% things to do to make the variables you want (eventually, save this as a "cleaning the data" script) 

% trial data
 - read in from files
 - add columns, from putNewColsIntoDataTable_1B(zRFAll_1B) function
 - remove shifts that weren't gracefully completed (Have to have SUM file read in for this)
 - find the isotonic estimates for each shift (maybe save these in a file)
    - also find the isotonic estimates for begining and end of each shift, from () function
 - find the kernel-regressed logit estimates for each shift (maybe save these in a file)
    - also find the kernel-regressed logit estimates for begining and end of each shift, from () function
 - find the GLM estimates (at least the overall Ability estimates, possibly per-EF estimates as well)
 - create a "first N shifts" (probably 40 shifts, or 2 days) variable
    - ZEPHY: alter this function to actually go by days, and get two days instead of 40 shifts (maybe?)
 
 % sum file
  - read in from file (might as well do data file at the same time)
  - remove shifts that weren't gracefully completed 
  - copy over and read in the isotonic estimates (if those estimates were done on another machine)
    - also, add columns with the logit of these beginning/end iso estimates
  - add isotonic beginning and end (have to get, read in, etc. the estimates from the trial data first)
  - copy over and read in the kernel-regressed logit estimates (if those estimates were done on another machine)
    - also, add columns with the logit of these beginning/end kernel-regressed logit estimates
  - add kernel-regressed logit beginning and end (have to get, read in, etc. the estimates from the trial data first)
  - add "first time seeing this cluster" info, with insertFirstTimeClusterFlagsIntoSum_1B(zRFSum_1B, false) function
  - remove clusters that were completed more than once, with removeDuplicateClustersCompleted_1B(zRFSum_1B, false) function
 !!! copy the overall Ability scores from the ECE server
 
 
 % data file
 - read in from file

