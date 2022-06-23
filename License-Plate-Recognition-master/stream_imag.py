import time
import cv2
from flask import Flask, render_template, Response
import warnings
import urllib.request
import numpy as np
warnings.filterwarnings("ignore")
from src.lp_recognition import E2E

urlCamera = 'http://192.168.1.41/cam-hi.jpg'
app = Flask(__name__)


@app.route('/')
def index():
    """Video streaming home page."""
    return render_template('index.html')


def gen():
    """Video streaming generator function."""
    cap = cv2.VideoCapture(0)
    model = E2E()
    # Read until video is completed
    while (cap.isOpened()):
        # Capture frame-by-frame
        # ret, img = cap.read()

        img_resp = urllib.request.urlopen(urlCamera)
        imgnp = np.array(bytearray(img_resp.read()), dtype=np.uint8)
        img = cv2.imdecode(imgnp, -1)
        img = cv2.resize(img, (0, 0), fx=0.5, fy=0.5)
        try:
            image = model.predict(img)
        except ValueError:
            image = img

        frame = cv2.imencode('.jpg', image)[1].tobytes()
        yield (b'--frame\r\n'b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
        time.sleep(0.1)


@app.route('/video_feed')
def video_feed():
    """Video streaming route. Put this in the src attribute of an img tag."""
    return Response(gen(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')