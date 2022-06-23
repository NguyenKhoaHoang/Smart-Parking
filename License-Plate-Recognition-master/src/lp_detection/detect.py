from .. import data_utils as utils
# import src.data_utils as utils
import cv2
import numpy as np


class detectNumberPlate(object):
    def __init__(self, classes_path, config_path, weight_path, threshold=0.5):
        self.weight_path = weight_path
        self.cfg_path = config_path
        self.labels = utils.get_labels(classes_path)
        self.threshold = threshold

        # Load model
        self.model = cv2.dnn.readNet(model=self.weight_path, config=self.cfg_path)

    def detect(self, image):
        boxes = []
        classes_id = []
        confidences = []
        scale = 0.00392  # 1/255

        # giảm kích thước pixel thành từ 0-1 thay vì từ 0-255, độ phân giải ảnh còn 416x416 thành 1 hình vuông, bức ảnh trở thành 1 ảnh trắng đen
        # blob = cv2.dnn.blobFromImage(image, scalefactor=scale, size=(416, 416), mean=(0, 0), swapRB=True, crop=False)
        blob = cv2.dnn.blobFromImage(image, scalefactor=1/255.0, size=(416, 416), swapRB=True, crop=False)
        # r = blob[0, 0, :, :]
        # cv2.imshow('blob', r)

        # lấy độ cao chiều dài hình ảnh
        height, width = image.shape[:2]

        # Đưa ảnh vào trong model
        self.model.setInput(blob)

        # chạy forward
        outputs = self.model.forward(utils.get_output_layers(self.model))

        for output in outputs:
            for i in range(len(output)):
                scores = output[i][5:]
                class_id = np.argmax(scores)
                confidence = float(scores[class_id])
                # Khi độ tin cậy lớn hơn ngưỡng thì tạo ra 1 cái box bao quanh biển số đã tìm thấy
                if confidence > self.threshold:
                    # lấy ra được X và Y của điểm chính giữa box bao quanh của biển số
                    center_x = int(output[i][0] * width)
                    center_y = int(output[i][1] * height)

                    # Chiều rộng và cao của box
                    detected_width = int(output[i][2] * width)
                    detected_height = int(output[i][3] * height)

                    # tính được điểm X và y của điểm bắt đầu góc trái của box
                    x_min = center_x - detected_width / 2
                    y_min = center_y - detected_height / 2

                    boxes.append([x_min, y_min, detected_width, detected_height])

                    classes_id.append(class_id)
                    confidences.append(confidence)

        indices = cv2.dnn.NMSBoxes(boxes, confidences, score_threshold=self.threshold, nms_threshold=0.4)


        coordinates = []
        for i in indices:
            index = i
            x_min, y_min, width, height = boxes[index]
            x_min = round(x_min)
            y_min = round(y_min)

            coordinates.append((x_min, y_min, width, height))
        # trả về tọa độ và chiều cao chiều rộng của box biển số xe
        return coordinates
