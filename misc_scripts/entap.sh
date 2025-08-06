#!/bin/bash
#SBATCH --job-name=entap
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=100gb
#SBATCH --time=24:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=eab77806@uga.edu
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.err

OUTDIR="/scratch/eab77806/salt_stress/genomes/Ha412/entap"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

## name variables:
# set output directory
# out='/path/to/output'
# path to input protein sequence fasta file
in='/scratch/eab77806/salt_stress/genomes/Ha412/Ha412HOv2.0-20181130.peptides.fa'

# load entap
ml EnTAP/1.0.0-foss-2022a

# run entap by blasting protein sequences against the eggnogg and uniprot/sprot protein database database
EnTAP --runP -i $in -t 12 -d /apps/db2/EnTAP/EggNOG_DIAMOND_Reference/bin/eggnog_proteins.dmnd -d /apps/db2/EnTAP/EggNOG_DIAMOND_Reference/bin/uniprot_sprot.dmnd --ini ~/entap_config.ini
