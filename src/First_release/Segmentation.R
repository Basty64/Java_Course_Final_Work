args = commandArgs(trailingOnly=TRUE)

# args = c("D:\\МИФИ\\Теория и техника программирования\\2022\\Экзамен", "test2.json" ,"145")

if (length(args)<4) {
  stop("Non all argument was mention (input file).n", call.=FALSE)
} else  {
  WD_PATH <- args[1]
  JSON_PATH <- args[2]
  ZLyaer <- as.numeric(args[3])
  bc <- as.numeric(args[4])
}
setwd(WD_PATH)

library(jsonlite)
library(reshape2)
library(plyr)
library(ggplot2)


print("Please, wait a lot, hard operation")
LOADED <- read_json(path = JSON_PATH, simplifyVector = TRUE)
print("Color Model Construction Begin")
longBind = LOADED$longBind
longTumor = LOADED$longTumor
longFull = LOADED$longFull
Borders = LOADED$Borders

if (!any(longTumor$Z == ZLyaer)){
  stop("No tumor in this Z-layer(((", call.=FALSE)
}else{
  print("There is a tumor in this Z-layer!!!")
}
Border <- Borders[Borders$Z == ZLyaer,]

# hist(x = longFull$value, breaks =  unique(longFull$value),right = FALSE,plot = FALSE) 
All_Colors_hist <- count(longFull,"value")
names(All_Colors_hist) <- c("breaks","counts")

findpeaks <- function(vec,bw=4){
  maxes <- numeric(length = 0)
  V <- length(vec)
  for (v in (bw+1):(V-bw)) {
    if(vec[v] == max(vec[(v - bw):(v+bw)]) ){
      maxes <- c(maxes, v)
    }
  }
  return(maxes)
}

AAA <- findpeaks(All_Colors_hist$counts)
longBind$Col <- 0
for (aaa in AAA) {
  OftenColor <- All_Colors_hist$breaks[aaa]
  ZColorsN <- c((OftenColor - bc):(OftenColor+bc) )
  longBind$Col[longBind$value %in% ZColorsN] <- OftenColor
}
longBind$Col <- as.factor(longBind$Col)

png(file = "segmentation.png", bg = "transparent",width = 1200, height = 800)
G5 <- ggplot(data = longBind[longBind$Z == ZLyaer,]) + 
  geom_tile(mapping = aes(x = X,y = Y,fill = Col)) + 
  geom_point(data = Border[Border$value == 1,],mapping = aes(x = X,y = Y),col = "black")+
  labs(title = "Сегментация на основе узкого цветового ряда")
print(G5)
dev.off()
