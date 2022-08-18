library("fslr")

setwd("/Users/loic/Dropbox/HAMOTA/SPM12_12hROIs_juin2020/hROIs nii")

chemin_fichier <- list.files(getwd(),
                             pattern = "*.nii.gz", # "*.nii" ou "*.img" ou "*.hdr"
                             full.names = TRUE)
region <- list()
aicha_number <- c(101,102,155,156,257,258,159,160,87,88,365,366,375,376,233,234,73,74,61,62,65,66,67,68,69,70)
for (i in 1:2){
  print(paste("region : ", i))
  tmp <- readnii(chemin_fichier[[i]])@.Data
  tmp[tmp!=0] <- aicha_number[i]
  region[[i]] <- tmp
  print(dim(region[[i]]))
}

aicha_atlas <- readnii("/Users/loic/Dropbox/A_aicha_v8/AICHA.nii")@.Data
dim(aicha_atlas) ; length(table(aicha_atlas))

aicha_atlas[!(aicha_atlas %in% aicha_number[-c(1,2)])] <- 0
dim(aicha_atlas) ; length(table(aicha_atlas)) ; table(aicha_atlas)
region[[3]] <- aicha_atlas


region <- Reduce(`+`, region)
dim(region) ; length(table(region)) ; table(region)

setwd("/Users/loic/Dropbox/HAMOTA/toolbox_site_HAMOTA_SPM12")
mask <- nifti(region)
mask <- copyNIfTIHeader(img = readnii("/Users/loic/Dropbox/A_aicha_v8/AICHA.nii"),
                             arr = mask)
writenii(mask, "HAMOTA.nii")