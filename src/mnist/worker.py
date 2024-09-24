# worker.py
import numpy as np
from PIL import Image
from keras.models import load_model
from tensorflow.keras.datasets import mnist
import os

# 모델 로드
model = load_model('mnist240924.keras')  # 학습된 모델 파일 경로

# 사용자 이미지 불러오기 및 전처리
def preprocess_image(image_path):
    img = Image.open(image_path).convert('L')  # 흑백 이미지로 변환
    img = img.resize((28, 28))  # 크기 조정

    # 흑백 반전
    # img = 255 - np.array(img)  # 흑백 반전
    img = np.array(img)
    
    img = img.reshape(1, 28, 28, 1)  # 모델 입력 형태에 맞게 변형
    img = img / 255.0  # 정규화
    return img

# 예측
def predict_digit(image_path):
    img = preprocess_image(image_path)
    prediction = model.predict(img)
    digit = np.argmax(prediction)
    return digit

(train_images, train_lables), (test_images, test_lables) = mnist.load_data()
train_images.shape

save_dir = 'train_img'
os.makedirs(save_dir, exist_ok=True)

def save_images(images, labels):
    for i, (imga, label) in enumerate(zip(images, labels)):
        img = Image.fromarray(imga)
        name = f'{label}_{i}.png'
        img.save(os.path.join(save_dir,name))

save_images(train_images, train_lables)
