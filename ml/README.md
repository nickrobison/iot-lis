# ML models for sample detection and analysis

This directory contains a collection of Ml models developed for the application.
We have both Tensorflow and CoreML models available.
Ideally, we'd move towards Tensorflow only, but as we're currently refining our training, we need CoreMl for now, as it's much more accurate.

### Setup

Setup is pretty tricky right now. For the TFLite converter, we need to use nightly, which conflicts with the installation the Tensorflow Object Detection API.
This means we currently need two python environments, one with TF+Object Detection and one with TF-nightly.

The [requirements.txt] file in the root directly has the required dependencies for installing the object detection API.
This should be the only environment you need for training on clusters, as we can export the tflite model quickly on a local machine.

Once the dependencies are installed, you'll need to install the [Object Detection API](https://github.com/tensorflow/models), which is available as a submodule.
Simple installation instructions:

```bash
cd samples/tf/models/research
protoc object_detection/protos/*.proto --python_out=.
# Install TensorFlow Object Detection API.
cp object_detection/packages/tf2/setup.py .
python -m pip install --use-feature=2020-resolver .
```

### Training flow

Overall, model training features a couple of specific steps.

1. Annotate images.
For this, we've been using [RectLabel](https://rectlabel.com) which makes it trivial to generate the corresponding annotations.

1. Build the training and test datasets.
For CoreML, this is done in RectLabel by exporting the required JSON file directly.
For Tensorflow, we can using the provided [generate_tfrecord.py](scripts/generate_tfrecord.py) script to combine both the data and the corresponding annotations.

```bash
python ml/scripts/generate_tfrecord.py -x {PATH_TO_IMAGE_DIR} -l {PATH_TO_ANNOTATIONS_DIR}/label_map.pbtxt -o {PATH_TO_ANNOTATIONS_DIR}/{test|train}.tfrecord
```

1. Train the model
CoreML trains locally using CreateML, for Tensorflow, we use Cades and Cori to handle the distributed training.

For Tensorflow training (which generates data in place):

```bash
python ml/tf/research/object_detection/model_main_tf2.py --model_dir {PATH_TO_MODEL} --{PATH_TO_MODEL/pipeline.config
```

1. Export the model to TFLite compatible Graph

```bash
python ml/tf/research/object_detection/export_tflite_graph_tf2.py --pipeline_config_path {PATH_TO_MODEL}pipeline.config --trained_checkpoint_dir {PATH_TO_MODEL}checkpoint --output_directory {PATH_TO_OUTPUT_DIRECTORY}
```

1. Compile the model to TFLite

> Note: Must be run using `tf-nightly`

The compilation script is provided, but you'll need to manually change the filenames (sorry)
```bash
python ml/scripts/convert.py
```

## Sample detection

This model detects the various sample types supported by the application.
It's built on an Object Detection model; Yolo, in the case of CoreML, and Resnet101 or MobileNet V2 for Tensorflow.
Resnet doesn't seem to work particularly well, but MobileNet is quick and accurate.

## Cluster setup

### CADES

Setup on CADES is pretty simple. Make sure you load the correct CUDA version (10.1) on the GPU nodes.

```bash
module load cuda/10.1
conda create -n tf-gpu python=3.7
source activate tf-gpu
conda install tensorflow-gpu

# Install object detection API
cd ml/tf/research
protoc object_detection/protos/*.proto --python_out=.
# Install TensorFlow Object Detection API.
cp object_detection/packages/tf2/setup.py .
python -m pip install --use-feature=2020-resolver .
```

A SLURM script is provided [here](scripts/cades-train.sh).
You'll need to change the filenames.
Sorry.

### CORI

```bash
module load python
conda create -n tf-gpu
source activate tf-gpu
conda install tensorflow-gpu

# Install object detection API
cd samples/tf/models/research
protoc object_detection/protos/*.proto --python_out=.
# Install TensorFlow Object Detection API.
cp object_detection/packages/tf2/setup.py .
python -m pip install --use-feature=2020-resolver .
```

A SLURM script is provided [here](scripts/cori-train.sh).
You'll need to change the filenames.
Sorry.

> Note: For CORI, you'll need to make sure you load the *esslurm* module. `module load esslurm`

# Additional docs
Given how fast the Tensorflow APIs change, there's a bunch of outdated documentation, here are some helpful docs for piecing it all together.

It's a little tricky, but some docs are here:

- https://github.com/tensorflow/models/blob/master/research/object_detection/colab_tutorials/eager_few_shot_od_training_tflite.ipynb
- https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html#annotate-the-dataset
- https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/install.html#tf-models-install
- https://coral.ai/docs/edgetpu/retrain-detection/#using-the-coral-usb-accelerator
