import cv2
import warnings
import urllib.request
import numpy as np
warnings.filterwarnings("ignore")
from src.lp_recognition import E2E

urlCamera = 'http://192.168.1.44/cam-lo.jpg'
# cv2.namedWindow("live transmission", cv2.WINDOW_AUTOSIZE)
cap_plate = cv2.VideoCapture(0)
# load model
model = E2E()
while True:
    # read image
    ret,img = cap_plate.read()
    # img_resp = urllib.request.urlopen(urlCamera)
    # imgnp = np.array(bytearray(img_resp.read()), dtype=np.uint8)
    # img = cv2.imdecode(imgnp, -1)

    # recognize license plate
    try:
        image = model.predict(img)
    except ValueError:
        image = img
    cv2.imshow('License Plate', image)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# cap_plate.release()
cv2.destroyAllWindows()