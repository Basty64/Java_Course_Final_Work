args = commandArgs(trailingOnly=TRUE)
# args = c("D:\\МИФИ\\Теория и техника программирования\\2022\\Экзамен",  "test2.json")

if (length(args)<2) {
  stop("Non all argument was mention (input file).n", call.=FALSE)
} else  {
  WD_PATH = args[1]
  JSON_PATH = args[2]
}
setwd(WD_PATH)
library(jsonlite)
library(reshape2)
library(plyr)
library(ggplot2)
print("Please, wait a lot, hard operation")
LOADED <- read_json(path = JSON_PATH, simplifyVector = TRUE)
print("Color Model Construction Begin")
longFull = LOADED$longFull
longKidney = LOADED$longKidney
longTumor = LOADED$longTumor
longBind = LOADED$longBind

longBind$TuF <- as.factor(longBind$TuF)

png(file = "dist1.png", bg = "transparent",width = 1200, height = 800)
G <- ggplot() + geom_density(data = longKidney,mapping = aes(x = value, fill = "noTumor") ,alpha = 0.5) + 
  geom_density(data = longTumor,mapping = aes(x = value, fill = "Tumor") ,alpha = 0.5) + 
  labs(title = "Эмпирическое распределение цветов опухоли и здоровых тканей")
print(G)
dev.off()



png(file = "dist2.png", bg = "transparent",width = 800, height = 600)
G2 <- ggplot() + stat_density(data = longBind,mapping = aes(x = value, group = TuF ,fill = TuF) ,alpha = 0.5) +
  labs(title = "Совместное эмпирическое распределение цветов опухоли и здоровых тканей")
print(G2)
dev.off()

png(file = "dist3.png", bg = "transparent",width = 1200, height = 800)
hist(x = longFull$value, breaks =  unique(longFull$value),right = FALSE, main = "Распределение цветов на снимке") 
All_Colors_hist <- count(longFull,"value")
names(All_Colors_hist) <- c("breaks","counts")
dev.off()