#!/bin/bash --login
#SBATCH --job-name=Raine_GWAS_pipeline
#SBATCH --account=pawsey0134
#SBATCH --partition=workq
#SBATCH --time=8:00:00
#SBATCH --export=NONE

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


####################
# ProbAbel Modules #
# Do not modify    #
####################

palogist="/group/pawsey0134/wcarol/probabel-0.4.1/probabel/bin/palogist"
palinear="/group/pawsey0134/wcarol/probabel-0.4.1/probabel/bin/palinear"
plink2="/group/pawsey0134/wcarol/executable/plink2"


###############################################
# Set up working directory

chr=${SLURM_ARRAY_TASK_ID}

SCRATCH=${wkdir}/chr${chr}
mkdir -p ${SCRATCH}

#############################################
#   Copy files to working directory
#   Modify phenotype and cov column names as required
#  	Submit job

cp ${genodir}/chr${chr}/chr${chr}_updatedID_GWAS1494_plink_binary.pgen.gz ${SCRATCH}
cp ${genodir}/chr${chr}/chr${chr}_updatedID_GWAS1494_plink_binary.psam.gz ${SCRATCH}
cp ${genodir}/chr${chr}/chr${chr}_updatedID_GWAS1494_plink_binary.pvar.gz ${SCRATCH}
gunzip ${SCRATCH}/chr${chr}_updatedID_GWAS1494_plink_binary.pgen.gz
gunzip ${SCRATCH}/chr${chr}_updatedID_GWAS1494_plink_binary.psam.gz
gunzip ${SCRATCH}/chr${chr}_updatedID_GWAS1494_plink_binary.pvar.gz


$plink2 --pfile ${SCRATCH}/chr${chr}_updatedID_GWAS1494_plink_binary --no-parents --no-sex --glm hide-covar --pheno ${phenodir}/${phenotype_filename} --pheno-name zHS_L --covar ${phenodir}/${cov_filename} --covar-name standAGE,gender,pc1,pc2 --out ${wkdir}/chr${chr}/results_chr${chr}

echo hostname job finished at  `date`
