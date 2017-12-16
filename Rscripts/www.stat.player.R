# -------------------------------------------------------------------
# - NAME:        www.stat.player.R
# - AUTHOR:      Reto Stauffer
# - DATE:        2014-12-22
# -------------------------------------------------------------------
# - DESCRIPTION: Creates some player statistics.
#                RETURN CODES:
#                0:   
#                1:   stop(...) was called somewhere in the code.
# -------------------------------------------------------------------
# - EDITORIAL:   2014-12-22, RS: Created file on pc24-c707.
# -------------------------------------------------------------------
# - L@ST MODIFIED: 2014-12-28 12:26 on prognose2.met.fu-berlin.de
# -------------------------------------------------------------------
# - First read in the arguments listed at the command line
args=(commandArgs(TRUE))

setwd("/var/www/Rscripts/");
Rimages <- "/var/www/html/Rimages";
library('wetterturnier')

# - If we are on the wetterturnier server, use
#   mysql mode. searching for ending ".de". This
#   should be fine when switching to wetterturnier.de
hostname <- system('hostname',intern=TRUE)
if ( substring(hostname,nchar(hostname)-2) == ".de" ) {
   WTinitialize(user='rouser',password='readonly',host='localhost',db='wpwt')
}

# - Args is now a list of character vectors
#   First check to see if arguments are passed.
#   Then cycle through each element of the list and evaluate the expressions.
if(length(args)==0){
    print("No arguments supplied.")
}else{

   for(i in 1:length(args)){
     cat(sprintf("  - Evaluating input argument: %s\n",args[i]))
     eval(parse(text=args[[i]]))
   }
   userID <- WT.check.user( as.numeric(userID) )

   # - Now plotting the shit
   file <- sprintf('%s/playerstat_%d.svg',Rimages,userID)
   svg(file=file,width=10,height=6)
         print( username <- WTgetuser(userID)$user_login )
   ret <- stat.player(userID)
   # - All fine
   if ( is.null(ret) ) {
      dev.off()
   } else if ( ! ret ) {
      # - Create new image containing sorry message.
      #   Why? If he tries again (or another user)
      #   the "no data image" is allready on the disc
      #   and we do not have to start this script again.
      svg(file=file,width=10,height=6)
         username <- WTgetuser(userID)$user_login
         main=sprintf('Sorry, cannot create the plot')
         text=sprintf('%s\n%s \"%s\"\n%s.','I cannot create the plot',
            'for the player',username,'No, or not enough data available.')
         par(mar=c(1,1,3,1),bty='o',xaxt='n',yaxt='n')
         plot(0,0,type='n',main=main,xlab='',ylab='')
         text(0,0,text,col='red')
         box(col='#FFCC00',lwd=2)
      dev.off()
   }
   
   quit('no',0,FALSE)
}

