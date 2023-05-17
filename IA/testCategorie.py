import tensorflow as tf
import numpy as np

categories = ['battery', 'paper', 'plastic', 'clothes']

# Charger le modèle TensorFlow Lite
model_path = 'resultat/model.tflite'
interpreter = tf.lite.Interpreter(model_path=model_path)
interpreter.allocate_tensors()

# Obtenir les informations sur les entrées et sorties du modèle
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Préparer l'image pour l'inférence
image_path = 'image/battery1.jpg'
image = tf.keras.preprocessing.image.load_img(image_path, target_size=(224, 224))
image = tf.keras.preprocessing.image.img_to_array(image)
image = image / 255.0  # Normaliser les pixels entre 0 et 1
image = np.expand_dims(image, axis=0)  # Ajouter une dimension supplémentaire

# Effectuer l'inférence
interpreter.set_tensor(input_details[0]['index'], image)
interpreter.invoke()
output = interpreter.get_tensor(output_details[0]['index'])

# Récupérer les pourcentages de concordance pour chaque catégorie
probabilities = tf.nn.softmax(output)[0]
predicted_categories = []
for i, probability in enumerate(probabilities):
    predicted_category = categories[i]
    predicted_categories.append((predicted_category, probability))

# Trier les catégories par ordre décroissant de probabilité
predicted_categories = sorted(predicted_categories, key=lambda x: x[1], reverse=True)

# Afficher les catégories prédites avec leur pourcentage de concordance
for predicted_category, probability in predicted_categories:
    print("Catégorie :", predicted_category)
    print("Pourcentage de concordance :", probability)
    print()

# Afficher la catégorie prédite avec le plus haut pourcentage de concordance
predicted_category, probability = predicted_categories[0]
print("Catégorie prédite :", predicted_category)
print("Pourcentage de concordance :", probability)
