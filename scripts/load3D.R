args = commandArgs(trailingOnly=TRUE)

library(nat)
library(jsonlite)

if (length(args)<4) {
  stop("Non all argument was mention (input file).n", call.=FALSE)
} else  {
  WD_PATH = args[1]
  vol_struct_file = args[2]
  kidney_tumor_file = args[3]
  JSON_PATH = args[4]
}
setwd(WD_PATH)

library(nat)
library(jsonlite)

vol_struct_file <- files$vol_struct_file
kidney_tumor_file <- files$kidney_tumor_file

AA <- read.amiramesh.header(vol_struct_file, Parse = TRUE, Verbose = FALSE)
vol_struct_full <- read.amiramesh(
  vol_struct_file,
  sections = NULL,
  header = FALSE,
  simplify = TRUE,
  endian = NULL,
  ReadByteAsRaw = FALSE,
  Verbose = FALSE
)

kidney_tumor_full <- read.amiramesh(
  kidney_tumor_file,
  sections = NULL,
  header = FALSE,
  simplify = TRUE,
  endian = NULL,
  ReadByteAsRaw = FALSE,
  Verbose = FALSE
)


N1 <- dim(vol_struct_full)
N2 <- dim(kidney_tumor_full)

if (any(N1 != N2)){
  e <- simpleError(message = "В переданных файлах несовпадающие измерения")
  stop(e)
} 
Tumor <- array(data = -1000,dim = N1)
Kidney <- array(data = -1000,dim = N2)
Full <- array(data = -1000,dim = N1)
Bigest_tumor_ind <- numeric(N1[3])
for (n in 1:N1[3]) {
  Full[,,n] <- vol_struct_full[,,n]
  Kidney[,,n] <- kidney_tumor_full[,,n]
  tumor <- Tumor[,,n]
  Bti <-  0
  for (m in 1:N1[2]) {
    A <- Full[,m,n] == Kidney[,m,n]
    B <- !A
    tumor[B,m] <- Full[B,m,n]
    Bti <- Bti + length(which(B))
  }
  Tumor[,,n] <- tumor
  Bigest_tumor_ind[n] <- Bti
  # print(paste0("Slade ", n))
}

Tumor0 <- (Tumor-(-1000))/( 2000  )
Tumor1 <- round(Tumor0*255)

Full0 <- (Full-(-1000))/( 2000  )
Full1 <- round(Full0*255)

Kidney0 <- (Kidney-(-1000))/( 2000  )
Kidney1 <- round(Kidney0*255)

Loaded <- list(Kidney = Kidney1, Full = Full1, Tumor = Tumor1)
write_json(x = Loaded,path = JSON_PATH)