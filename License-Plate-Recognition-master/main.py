import cv2
from pathlib import Path
import argparse
from urllib.request import urlopen
import time
import numpy as np

from src.lp_recognition import E2E


def get_arguments():
    arg = argparse.ArgumentParser()
    arg.add_argument('-i', '--image_path', help='link to image', default='./samples/light.jpg')

    return arg.parse_args()


args = get_arguments()
img_path = Path(args.image_path)




# read image
img = cv2.imread(str(img_path))

# req = urlopen("http://192.168.1.69/cam-mid.jpg")
# arr = np.asarray(bytearray(req.read()), dtype=np.uint8)
# img = cv2.imdecode(arr, -1) # 'Load it as it is'

# cv2.imshow('lalala', img)
# if cv2.waitKey() & 0xff == 27: quit()



# load model
model = E2E()

# start
start = time.time()

# recognize license plate
image = model.predict(img)

# end
end = time.time()

print('Model process on %.2f s' % (end - start))

# show image
cv2.imshow('License Plate', image)
if cv2.waitKey(0) & 0xFF == ord('q'):
    exit(0)

cv2.destroyAllWindows()
