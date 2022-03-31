#!/bin/bash --login
#SBATCH --job-name=Raine_GWAS_pipeline
#SBATCH --account=pawsey0134
#SBATCH --partition=workq

# Default loaded compiler module is gcc module.
# To compile with the GNU compiler, load the gcc module in case.
module load gcc 
module load r
module load probabel

# leave in, it lists the environment loaded by the modules
module list

#  Note: SLURM_JOBID is a unique number for every job.
#  These are generic variables

echo hostname job started at  `date`

#######################
#  Modules  & Scripts #
#######################

palogist="/group/pawsey0134/wcarol/probabel-0.4.1/probabel/bin/palogist"
palinear="/group/pawsey0134/wcarol/probabel-0.4.1/probabel/bin/palinear"
plink2="/group/pawsey0134/wcarol/executable/plink2"

gwasscript=gwas_example.slurm

########################
# Parameters to edit  ##
########################
#Specify username
#Specify projet title

	
formatteddate=20210817
username=wcarol
projecttitle=test
phenotype_filename=gwasHS_L_plinkpheno.txt
cov_filename=gwasHS_L_plinkcov.txt

gen=Gen2
platform=Raine660W #Raine660W or RaineOmni
reference=TOPMed #HRC or 1KGP3 or TOPMed

###############
# Specify directories
###############
currdir=/scratch/pawsey0134/${username}/testGWAS_TM/ # Directory where job is initiated
genodir=/group/pawsey0134/data/GWAS/${gen}_${platform}/Imputed/${reference}/ # geno directory
phenodir=/scratch/pawsey0134/${username}/${projecttitle}/ # phenofile directory
wkdir=/scratch/pawsey0134/${username}/run_pipeline/${SLURM_JOBID}/ # output directory 
##################


sbatch --export=genodir=${genodir},phenodir=${phenodir},wkdir=${wkdir},phenotype_filename=${phenotype_filename},cov_filename=${cov_filename} --array=1-22 -J array --account=pawsey0134 --partition=workq --time=8:00:00 --mem=8gb ${currdir}/${gwasscript}
