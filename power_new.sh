#!/bin/bash
#SBATCH -J slim_power
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH -t 24:00:00
#SBATCH --mem=8G
#SBATCH -p standard
#SBATCH --account=berglandlab

# Number of replicates = size of array
#SBATCH --array=1-100

#SBATCH --output=/scratch/cqh6wn/AOD_slim/Distribution/Inversions/1/TO/Power/logs/power.%A_%a.out
#SBATCH --error=/scratch/cqh6wn/AOD_slim/Distribution/Inversions/1/TO/Power/logs/power.%A_%a.err


module purge
module load slim

cd /scratch/cqh6wn/AOD_slim/Distribution/Inversions/1/TO/Power || exit 1


TASK_ID=${SLURM_ARRAY_TASK_ID}
REP_ID=${TASK_ID}

OUTFILE="power_chunk_${TASK_ID}.csv"
rm -f ${OUTFILE}

echo "Starting TASK ${TASK_ID} (replicate ${REP_ID}) at $(date)"
echo "Output file: ${OUTFILE}"

## Parameters
MODELS=("AOD" "AOD_TO")

K_LIST=(300 500 1000)
G_LIST=(10 15 20)
S_LIST=(50 100 200)
FOUNDERS_LIST=(10 20 40)


for MODEL in "${MODELS[@]}"; do
  for K in "${K_LIST[@]}"; do
    for G in "${G_LIST[@]}"; do
      for S in "${S_LIST[@]}"; do
        for F in "${FOUNDERS_LIST[@]}"; do

          echo "RUN: REP=${REP_ID} MODEL=${MODEL} K=${K} G=${G} S=${S} FOUNDERS=${F}"

          slim \
            -d MODEL_TYPE=\"${MODEL}\" \
            -d K_CAGE=${K} \
            -d NUM_GEN=${G} \
            -d N_SAMPLE=${S} \
            -d N_FOUNDERS_HIGH=${F} \
            -d REP_ID=${REP_ID} \
            -d OUTFILE=\"${OUTFILE}\" \
            phase3_power.slim

        done
      done
    done
  done
done

echo "Finished TASK ${TASK_ID} at $(date)"
