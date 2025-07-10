#!/bin/bash
#SBATCH --job-name=snakemake_hybpiper
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2gb
#SBATCH --time=140:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.error

# load modules; poetry needed for snakemake to use pandas for some reason
ml poetry/1.8.3-GCCcore-13.3.0
ml snakemake/8.16.0-foss-2023a

snakemake --profile /home/eab77806/.config/slurm_profile/ \
--directory /scratch/eab77806/salt_stress/ \
--configfile /home/eab77806/sunflower_stress/config/config.yaml \
--use-envmodules