import tensorflow as tf
import sys

model_dir = sys.argv[1]
output_file = sys.argv[2]

print("Model {}".format(model_dir))

converter = tf.lite.TFLiteConverter.from_saved_model(model_dir)
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS,
                                       tf.lite.OpsSet.SELECT_TF_OPS]
converter.experimental_new_converter = True
converter.allow_custom_ops = False
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_types = [tf.float16]
#def representative_dataset_gen():
#  for _ in range(num_calibration_steps):
#    # Get sample input data as a numpy array in a method of your choosing.
#    yield [input]
#converter.representative_dataset = representative_dataset_gen
#converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
#converter.inference_input_type = tf.uint8  # or tf.uint8
#converter.inference_output_type = tf.uint8  # or tf.uint8
tflite_model = converter.convert()

with open(output_file, 'wb') as f:
  f.write(tflite_model)
