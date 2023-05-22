
import tensorflow as tf
import os


base_dir = './archive/garbage_classification'  # setting the base_dir variable to the location of the dataset containing the images

# now we will do some preprocessing, i.e we are preparing the raw data to make it suitable for a building and training models
IMAGE_SIZE = 224  # image size that we are going to set the images in the dataset to.
BATCH_SIZE = 10  # the number of images we are inputting into the neural network at once.

datagen = tf.keras.preprocessing.image.ImageDataGenerator(  # preprocessing our image
    rescale = 1./255,
    # firstly, rescaling it to 1/255 which will make the file size smaller, hence reducing the training time
    validation_split=0.2  # secondly, normally a dataset has a test set and a training set,
    # validation set is normally to test our neural network,which would give us a measure of accuracy on how well the neural network will do on the predictions.
    # here we are telling keras to use 20% for validation and 80% training
)

train_generator = datagen.flow_from_directory(  # training generator
    base_dir,  # the directory having the fruits and vegetable photos
    target_size=(IMAGE_SIZE, IMAGE_SIZE),  # converting images to 224 by 224
    batch_size = BATCH_SIZE,  # images getting inputed into the neural network through each epoch or each step
    subset='training'  # the name we will call it
)
val_generator = datagen.flow_from_directory(  # validation generator
    base_dir,
    target_size=(IMAGE_SIZE, IMAGE_SIZE),
    batch_size=BATCH_SIZE,
    subset='validation'
)
# So as we can see from below, our training generator dataset 2872 images and the validation generator dataset has 709 images


# Next we have to create a labels.txt file that will hold all our labels (important for Flutter)
print(train_generator.class_indices)  # prints every single key and class of that dataset
labels = '\n'.join(sorted
    (train_generator.class_indices.keys()))  # print all these keys as a list of labels into a text file called labels.txt
with open('labels.txt', 'w') as f:  # writes to the labels.txt file, and if it doesnt exists, it creates one, and if it does exist, it will overrite it. (thats what 'w' is for)
    f.write(labels)

# preprocessing of raw data is hence complete and now its time to build our neural network


# building a neural network using transfer learning method where we take a pretrained neural network called MobileNetV2 which is a convolutional neural network architecture that seeks to perform well on mobile devices and can predict up to 80 different classes
# we are going to have a base model on top of which we are going to add pre trained neural network to have it predict the classes we want
IMG_SHAPE = (IMAGE_SIZE, IMAGE_SIZE, 3)
base_model = tf.keras.applications.MobileNetV2(  # grabbing pretrained neural network of choice
    input_shape=IMG_SHAPE,
    include_top=False,
    # this will freeze all the weights, because we dont have to retrain and change the weights, instead just add on to the MobileNetV2 CNN, so it clasiffies 5 classes instead of 80
    weights='imagenet'
)


base_model.trainable =False  # this freezes all the neurons for our base model
model = tf.keras.Sequential([  # neural networks act in a sequence of layers, so we add layers as we want
    base_model,
    tf.keras.layers.Conv2D(32 ,3, activation = 'relu'),
    # This layer creates a convolution kernel that is convolved with the layer input to produce a tensor of outputs. Bascially, it trying to understand the patterns of the image
    tf.keras.layers.Dropout(0.2),
    # This layer prevents Neural Networks from Overfitting, i.e being too precise to a point where the NN is only able to recognize images that are present in the dataset
    tf.keras.layers.GlobalAveragePooling2D(),
    # This layer calculates the average output of each feature map in the previous layer, thus reducing the data significantly and preparing the model for the final layer

    #Il faut absolument changer la valeur par le nombre de classes totales
    tf.keras.layers.Dense(12,  # no.of classes
                          activation='softmax')
])



model.compile(
    optimizer=tf.keras.optimizers.Adam(),
    # Adam is a popular optimiser, designed specifically for training deep neural networks
    loss='categorical_crossentropy',
    metrics=['accuracy']
)


epochs = 10  # higher the epochs, more accurate is the NN, however it could cause Overfitting, if too high
history = model.fit(
    train_generator,
    epochs = epochs,
    validation_data=val_generator
)

# now that we have our neural network trained with tensorflow and keras, we can export it
saved_model_dir = ''  # means current directory
tf.saved_model.save(model, saved_model_dir)  # saves to the current directory

converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
tflite_model = converter.convert()  # converts our model into a .tflite model which flutter uses for ondevice machine learning

with open('model.tflite', 'wb') as f:  # to write the converted model into a file, written as binary so add 'wb' instead of 'w'
    f.write(tflite_model)

