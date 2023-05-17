import tensorflow as tf
import os
import numpy as np
from keras.applications import EfficientNetB0

# Liste des catégories de déchets
categories = ['battery','paper','plastic','clothes']

# Chemin vers le dossier principal contenant les images de déchets
data_dir = 'archive/garbage_classification'

# Charger les images et les étiqueter
data = []
labels = []

for category_index, category in enumerate(categories):
    category_dir = os.path.join(data_dir, category)
    for image_file in os.listdir(category_dir):
        image_path = os.path.join(category_dir, image_file)
        image = tf.keras.preprocessing.image.load_img(image_path, target_size=(224, 224))
        image = tf.keras.preprocessing.image.img_to_array(image)
        data.append(image)
        labels.append(category_index)

# Convertir les listes en tableaux numpy
data = np.array(data)
labels = np.array(labels)

# Vérifier la taille des données
print("Nombre total d'images :", len(data))
print("Forme des données d'entrée :", data.shape)
print("Forme des étiquettes :", labels.shape)

num_classes = len(categories)

model = tf.keras.Sequential([
    tf.keras.layers.Input(shape=(224, 224, 3)),
    tf.keras.layers.Lambda(lambda x: x / 255.0),
    EfficientNetB0(include_top=False, pooling='avg'),
    tf.keras.layers.Dense(num_classes, activation='softmax')
])

# Compiler le modèle
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# Entraîner le modèle
# Faire varier nombre de epochs à 10
model.fit(data, labels, epochs=10, validation_split=0.2)

# Convertir le modèle en format TensorFlow Lite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Sauvegarder le modèle TensorFlow Lite sur le disque
with open('resultat/model.tflite', 'wb') as f:
    f.write(tflite_model)