import cv2
import warnings
import urllib.request
import numpy as np
warnings.filterwarnings("ignore")
from src.lp_recognition import E2E
import time

urlCamera = 'http://192.168.1.69/cam-hi.jpg'
# cv2.namedWindow("live transmission", cv2.WINDOW_AUTOSIZE)
# cap_plate = cv2.VideoCapture(0)
# load model
model = E2E()
while True:
    # read image
    # ret,img = cap_plate.read()

    img_resp = urllib.request.urlopen(urlCamera)
    imgnp = np.array(bytearray(img_resp.read()), dtype=np.uint8)
    img = cv2.imdecode(imgnp, -1)

    # recognize license plate
    try:
        start = time.time()

        image = model.predict(img)

        # end
        end = time.time()
        print('Model process on %.2f s' % (end - start))
    except ValueError:
        image = img
    cv2.imshow('License Plate', image)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break


# # read 1 img
# img = cv2.imread('./samples/41.jpg')
# image = model.predict(img)
# # show image
# cv2.imshow('License Plate', image)
# if cv2.waitKey(0) & 0xFF == ord('q'):
#     exit(0)

# cap_plate.release()
cv2.destroyAllWindows()
