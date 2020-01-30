pheno0=read.table("phenotype0.txt") #read phenotype data
binary_pheno0=pheno0
binary_pheno0[binary_pheno0>=0]=1 #code values greater than 0 as 1
binary_pheno0[binary_pheno0<0]=2 #code values less than 0 as 2
write.table(binary_pheno0,"binary_phenotype0.txt",quote=F,row.names=F,col.names=F,sep=" ") #save binary phenotype data

system("paste famID.txt gender.txt binary_phenotype0.txt > binary_phenotype.txt")

binary_pheno<-read.table("binary_phenotype.txt")
head(binary_pheno)

system("plink --noweb --file genotype --assoc --pheno binary_phenotype.txt --adjust --all-pheno --out younameit")

# Manhattan Plot
system("awk '{print $1,$2,$3,$9}' younameit.P1.assoc > P1.assoc")
system("awk '{print $1,$2,$3,$9}' younameit.P2.assoc > P2.assoc")
system("awk '{print $1,$2,$3,$9}' younameit.P3.assoc > P3.assoc")
system("awk '{print $1,$2,$3,$9}' younameit.P4.assoc > P4.assoc")

traits=c("binary_r_met", "binary_s_met", "binary_r_eddp", "binary_s_eddp") #name of four traits
traits=as.matrix(traits) #create a matrix from traits

library(qqman)
i=1 #i=2/i=3/i=4
assoc=read.table(paste0("P", i, ".assoc"), header=T)
assoc=assoc[assoc$CHR!=0,]

#Q-Q plot
png(filename=paste0("Q-Q_Plot_for_", traits[i], ".png"), type="cairo")
qq(assoc$P)
dev.off()

img <- readPNG("Q-Q_Plot_for_binary_r_met.png")
grid::grid.raster(img)

img <- readPNG("Q-Q_Plot_for_binary_s_met.png")
grid::grid.raster(img)

img <- readPNG("Q-Q_Plot_for_binary_r_eddp.png")
grid::grid.raster(img)

img <- readPNG("Q-Q_Plot_for_binary_s_eddp.png")
grid::grid.raster(img)