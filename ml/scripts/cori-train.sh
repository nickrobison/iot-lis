#!/bin/bash
#SBATCH -N 1
#SBATCH -c 30
#SBATCH -J sample-train
#SBATCH -t 4:00:00
#SBATCH -G 4
#SBATCH -C gpu
#SBATCH -o train-%j.out
#SBATCH -e train-%j.out

module load python
source activate tf-gpu

srun python ../tf/research/object_detection/model_main_tf2.py --model_dir samples/models/samples_ssd_resnet_50/ --pipeline_config_path samples/models/samples_ssd_resnet_50/pipeline.config