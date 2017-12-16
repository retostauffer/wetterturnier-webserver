# -------------------------------------------------------------------
# - NAME:        www.stat.player.R
# - AUTHOR:      Reto Stauffer
# - DATE:        2014-12-22
# -------------------------------------------------------------------
# - DESCRIPTION:
# -------------------------------------------------------------------
# - EDITORIAL:   2014-12-22, RS: Created file on pc24-c707.
# -------------------------------------------------------------------
# - L@ST MODIFIED: 2014-12-23 14:33 on prognose2.met.fu-berlin.de
# -------------------------------------------------------------------
# - First read in the arguments listed at the command line
args=(commandArgs(TRUE))

setwd("/var/www/Rscripts/");
Rimages <- "/var/www/html/Rimages";
library('wetterturnier')

# - Args is now a list of character vectors
#   First check to see if arguments are passed.
#   Then cycle through each element of the list and evaluate the expressions.
if(length(args)==0){
    print("No arguments supplied.")
}else{

   # - Reference (if not set) is Petrus
   refuser <- WTgetuser('Petrus')$ID
   # - Init value for the city
   city  <- NULL
   # - Catching the users.
   users <- NULL
   for(i in 1:length(args)){
      if ( grepl('user=',args[[i]]) ) {
         users <- c(users,as.numeric(strsplit(args[[i]],'=')[[1L]][2L])) 
      } else {
         eval(parse(text=args[[i]]))
      }
   }

   # - Exit if there are no defined users.
   if ( is.null(users) ) stop('No users defined!')
   if ( is.null(city)  ) stop('No city defined!')

   # - Numeric values
   city    <- WT.check.city( city )
   refuser <- WT.check.user( refuser )
   for ( usr in users ) x <- WT.check.user( usr )

   # - Now plotting the shit
   random_hash <- paste0(sample(c(letters,LETTERS),10,replace=TRUE),collapse='')
   file <- sprintf('%s/tteststat_%s.svg',Rimages,random_hash)
   svg(file=file,width=10,height=6)
   stat.ttest(city,refuser,users)
   dev.off()

   # - Has to be last line!
   cat(sprintf('%s\n',file))
   
}

