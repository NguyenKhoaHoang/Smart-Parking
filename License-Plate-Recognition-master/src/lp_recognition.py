from .data_utils import order_points, convert2Square, draw_labels_and_boxes
from .lp_detection.detect import detectNumberPlate
from .char_classification.model import CNN_Model
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import cv2
import numpy as np
from skimage import measure
from imutils import perspective
import imutils
from skimage.filters.thresholding import threshold_local
import requests
import pytesseract as pt

ALPHA_DICT = {0: 'A', 1: 'B', 2: 'C', 3: 'D', 4: 'E', 5: 'F', 6: 'G', 7: 'H', 8: 'K', 9: 'L', 10: 'M', 11: 'N', 12: 'P',
              13: 'R', 14: 'S', 15: 'T', 16: 'U', 17: 'V', 18: 'X', 19: 'Y', 20: 'Z', 21: '0', 22: '1', 23: '2',
              24: '3',
              25: '4', 26: '5', 27: '6', 28: '7', 29: '8', 30: '9', 31: "Background"}

LP_DETECTION_CFG = {
    "weight_path": "./src/weights/yolov3-tiny_15000.weights",
    "classes_path": "./src/lp_detection/cfg/yolo.names",
    "config_path": "./src/lp_detection/cfg/yolov3-tiny.cfg"
}

CHAR_CLASSIFICATION_WEIGHTS = './src/weights/weight.h5'
# url = 'http://192.168.1.169:81/smart-parking/get-plate.php'
url = 'https://smart-parking-pbl5.herokuapp.com/get-plate.php'

class E2E(object):
    def __init__(self):
        self.image = np.empty((28, 28, 1))
        self.detectLP = detectNumberPlate(LP_DETECTION_CFG['classes_path'], LP_DETECTION_CFG['config_path'],
                                          LP_DETECTION_CFG['weight_path'])
        self.recogChar = CNN_Model(trainable=False).model
        self.recogChar.load_weights(CHAR_CLASSIFICATION_WEIGHTS)
        self.candidates = []
        self.character_in_plate = []

    # hàm lấy ra được tọa độ và chiều cao chiều rộng box bao quanh biển số
    def extractLP(self):
        coordinates = self.detectLP.detect(self.image)
        if len(coordinates) == 0:
            ValueError('No images detected')

        for coordinate in coordinates:
            yield coordinate

    def predict(self, image):
        # Input image or frame
        self.image = image

        for coordinate in self.extractLP():  # detect license plate by yolov3
            self.candidates = []

            # convert (x_min, y_min, width, height) to coordinate(top left, top right, bottom left, bottom right)
            # chuyển đổi tọa độ điểm bắt đầu và kích thước thành tọa độ 4 điểm ở 4 góc box bao quanh
            pts = order_points(coordinate)

            # crop number plate used by bird's eyes view transformation
            # cắt ảnh chỉ còn lại vùng chứa biển số
            LpRegion = perspective.four_point_transform(self.image, pts)

            # cv2.imshow("crop", LpRegion)

            # segmentation
            # phân đoạn ký tự
            self.segmentation(LpRegion)

            # recognize characters
            # nhận dạng ký tự
            self.recognizeChar()

            # format and display license plate
            # Kiểm tra biển số 1 dòng hay 2 dòng và lấy về chuỗi string biển số
            license_plate = self.format()

            # Nếu biển số có độ dài < 4 thì chỉ vẽ cái box
            if len(license_plate) < 4:
                self.image = draw_labels_and_boxes(self.image, "", coordinate)
            else:
                # draw labels
                # vẽ cái box và labels là biển số nhận diện được
                self.image = draw_labels_and_boxes(self.image, license_plate, coordinate)
                # print(license_plate)
                plate_php = {'plate': license_plate}
                r = requests.post(url=url, data=plate_php)
                response = r.text
                print("The response is:%s" % response)
        return self.image

    def segmentation(self, LpRegion):
        # apply thresh to extracted licences plate

        # Chuyển màu ảnh biển số RGB được cắt ra thành màu xám HSV
        # H(Hue): vùng chứa màu sắc
        # S(Saturation): độ bão hòa
        # V(Value): độ sáng
        # Ở đây ta dùng chỉ giá trị độ sáng (V) của từng pixel để lọc ra các ký tự
        V = cv2.split(cv2.cvtColor(LpRegion, cv2.COLOR_BGR2HSV))[2]
        # cv2.imshow("V", V)

        # adaptive threshold
        # Nhị phân hóa hình ảnh từ ảnh xám
        # T = threshold_local(V, 15, offset=10, method="gaussian")
        #
        # # Lấy các pixcel
        # thresh = (V > T).astype("uint8") * 255
        # cv2.imshow("adaptive", thresh)

        thresh = cv2.adaptiveThreshold(V,
                                       maxValue=255,
                                       adaptiveMethod=cv2.ADAPTIVE_THRESH_MEAN_C,
                                       thresholdType=cv2.THRESH_BINARY,
                                       blockSize=15,
                                       C=8)
        # cv2.imshow("thresh", thresh)

        # convert black pixel of digits to white pixel
        # Chuyển pixel màu đen thành màu trắng và ngược lại
        thresh = cv2.bitwise_not(thresh)
        thresh = imutils.resize(thresh, width=400)
        thresh = cv2.medianBlur(thresh, 5)

        # text = pt.image_to_string(thresh)
        # print("textne",text)

        # cv2.imshow("convert", thresh)


        # connected components analysis
        # Kết nối các pixel bên cạnh có cùng giá trị thành một khối và gán 1 khối 1 nhãn label
        labels = measure.label(thresh, connectivity=2, background=0)

        # loop over the unique components
        # Lặp qua từng khối trong labels
        for label in np.unique(labels):
            # if this is background label, ignore it
            # Nếu là background thì tiếp tục vòng lặp for khác
            if label == 0:
                continue

            # init mask to store the location of the character candidates
            # tạo ra một mặt nạ để giữ các đường viền của các khối
            mask = np.zeros(thresh.shape, dtype="uint8")
            mask[labels == label] = 255

            # find contours from mask
            # Tạo các đường viền bao quanh các khối trong mặt nạ
            contours, hierarchy = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

            # có ít nhất một đường viền được tìm thấy trong mặt nạ
            if len(contours) > 0:
                # lấy đường viền lớn nhất tương ứng với phần trong mask và lấy box bao quanh cho đường viền
                contour = max(contours, key=cv2.contourArea)
                (x, y, w, h) = cv2.boundingRect(contour)

                # rule to determine characters
                # các nguyên tắc để xác định là một ký tự:
                # aspect ratio(tỉ lệ rộng / dài),
                # solidity(tỉ lệ diện tích phần bao quanh ký tự và hình chữ nhật bao quanh ký tự
                # height ratio(tỉ lệ chiều dài ký tự/chiều dài biển số)
                aspectRatio = w / float(h)
                solidity = cv2.contourArea(contour) / float(w * h)
                heightRatio = h / float(LpRegion.shape[0])


                if 0.1 < aspectRatio < 1.0 and solidity > 0.1 and 0.35 < heightRatio < 2.0:
                    # extract characters
                    # lấy ra được mặt nạ chứa ký tự thỏa mãn đều kiện
                    # cv2.imshow("mask", mask)
                    # hull = cv2.convexHull(contour)
                    # cv2.drawContours(mask, [hull], -1, 255, -1)
                    # cv2.imshow("mask", mask)
                    # lấy ra được phần ký tự có trong mặt nạ
                    candidate = np.array(mask[y:y + h, x:x + w])
                    square_candidate = convert2Square(candidate)
                    square_candidate = cv2.resize(square_candidate, (28, 28), cv2.INTER_AREA)
                    square_candidate = square_candidate.reshape((28, 28, 1))

                    # cv2.imshow("square_candidate", square_candidate)

                    # Lưu ký tự và vị trí đã được tách ra từ biển số vào mảng
                    self.candidates.append((square_candidate, (y, x)))
                    self.character_in_plate.append(square_candidate)




    def recognizeChar(self):
        characters = []
        coordinates = []

        for char, coordinate in self.candidates:

            characters.append(char)
            coordinates.append(coordinate)

        # Dự đoán ký tự và lấy ra vị trí ký tự trong bảng từ ALPHA_DICT gồm 32 ký tự
        characters = np.array(characters)
        result = self.recogChar.predict_on_batch(characters)
        result_idx = np.argmax(result, axis=1)


        self.candidates = []
        for i in range(len(result_idx)):
            # nếu vị trí ký tự là 31 thì là background hoặc nhiễu, ta bỏ qua nó
            if result_idx[i] == 31:  # if is background or noise, ignore it
                continue
            # gán giá trị ký tự lấy được trong mảng và tọa độ của nó
            self.candidates.append((ALPHA_DICT[result_idx[i]], coordinates[i]))

        character = cv2.hconcat(self.character_in_plate)
        print([c[0] for c in self.candidates])
        # cv2.imshow('character',character)
        self.character_in_plate = []





    def format(self):
        first_line = []
        second_line = []
        for candidate, coordinate in self.candidates:
            # Nếu tọa độ chiều cao y của từ mà bé hơn tọa độ chiều cao y của từ đầu tiên + 40 thì add ký tự và tọa độ x vào line 1, nếu lớn hơn thì add vào line 2
            if self.candidates[0][1][0] + 40 > coordinate[0]:
                first_line.append((candidate, coordinate[1]))
            else:
                second_line.append((candidate, coordinate[1]))

        # Sắp xếp mảng theo tứ tự từ bé đến lớn tọa độ x
        def take_second(s):
            return s[1]
        first_line = sorted(first_line, key=take_second)
        second_line = sorted(second_line, key=take_second)

        # Gắn các ký tự vào 1 chuỗi String
        if len(second_line) == 0:  # if license plate has 1 line
            license_plate = "".join([str(ele[0]) for ele in first_line])
        else:  # if license plate has 2 lines
            license_plate = "".join([str(ele[0]) for ele in first_line]) + "-" + "".join(
                [str(ele[0]) for ele in second_line])

        return license_plate
