myscript <- quote({
    print(Sys.time())
    print(getwd())
    print("hello world")
})

## Not run: 

## Run script once at a specific timepoint (within 62 seconds)
runon <- format(Sys.time() + 62, "%H:%M")
task_create(taskname = "myfancyscript", rscript = myscript, 
 schedule = "ONCE", starttime = runon)

## Run every day at the same time on 09:10, starting from tomorrow on
## Mark: change the format of startdate to your locale if needed (e.g. US: %m/%d/%Y)
task_create(taskname = "myfancyscriptdaily", rscript = myscript, 
 schedule = "DAILY", starttime = "09:10", startdate = format(Sys.Date()+1, "%d/%m/%Y"))
 
## Run every week on Sunday at 09:10
task_create(taskname = "myfancyscript_sun", rscript = myscript, 
  schedule = "WEEKLY", starttime = "09:10", days = 'SUN')

## Run every 5 minutes, starting from 10:40
task_create(taskname = "myfancyscript_5min", rscript = myscript,
  schedule = "MINUTE", starttime = "10:40", modifier = 5)
  
## Run every minute, giving some command line arguments which can be used in the script itself
task_create(taskname = "myfancyscript_withargs_a", rscript = myscript,
  schedule = "MINUTE", rscript_args = "productxyz 20160101")
task_create(taskname = "myfancyscript_withargs_b", rscript = myscript,
  schedule = "MINUTE", rscript_args = c("productabc", "20150101"))
  
# alltasks <- task_ls()
# subset(alltasks, TaskName %in% c("myfancyscript", "myfancyscriptdaily"))
# The field TaskName might have been different on Windows with non-english language locale

task_delete(taskname = "myfancyscript")
task_delete(taskname = "myfancyscriptdaily")
task_delete(taskname = "myfancyscript_sun")
task_delete(taskname = "myfancyscript_5min")
task_delete(taskname = "myfancyscript_withargs_a")
task_delete(taskname = "myfancyscript_withargs_b")

## End(Not run)
