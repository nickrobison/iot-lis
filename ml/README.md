# Model training

We use a simple ML model to detect Antigen test cards (e.g. Abbott Binax) for both positive and negative tests.

Building it requires installing both tensorflow and the tensorflow object-detection api.

It's a little tricky, but some docs are here:

- https://github.com/tensorflow/models/blob/master/research/object_detection/colab_tutorials/eager_few_shot_od_training_tflite.ipynb
- https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html#annotate-the-dataset
- https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/install.html#tf-models-install
