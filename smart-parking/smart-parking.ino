//*******************************libraries********************************
//RFID-----------------------------
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <SPI.h>
#include <MFRC522.h>
#include <SoftwareSerial.h>
#include <Servo.h> //includes the servo library
//NodeMCU--------------------------
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
//************************************************************************
#define SS_PIN  D3  //D3
#define RST_PIN D0  //D0
const char* device_token  = "8ceb36c810343326";
LiquidCrystal_I2C lcd(0x27,16,2);
String number_empty;
//************************************************************************
//String URL = "http://192.168.1.19:81/smart-parking/getdata.php";
#define ServoPort D4 
Servo myservo1;
//************************************************************************
MFRC522 mfrc522(SS_PIN, RST_PIN); // Create MFRC522 instance.
//************************************************************************
/* Set these to your desired credentials. */
const char *ssid = "khoahoang";
const char *password = "hoang135792486"; //computer IP or the server domain
String URL = "http://smart-parking-pbl5.herokuapp.com/getdata.php"; //computer IP or the server domain
String getData, Link;
//********************connect to the WiFi******************
void connectToWiFi(){
    WiFi.mode(WIFI_OFF);        //Prevents reconnection issue (taking too long to connect)
    delay(1000);
    WiFi.mode(WIFI_STA);
    Serial.print("Connecting to ");
    Serial.println(ssid);
    WiFi.begin(ssid, password);
    
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    Serial.println("");
    Serial.println("Connected");
  
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());  //IP address assigned to your ESP
    
    delay(1000);
}
//************************************************************************
void setup() {
  // Print a message to the LCD.
  Wire.begin(D1,D2);
  lcd.init();
  lcd.clear();
  lcd.backlight();
  myservo1.attach(ServoPort);
  myservo1.write(0);
  //delay(1000);
  Serial.begin(115200);
  delay(100);
  SPI.begin();  // Init SPI bus
  mfrc522.PCD_Init(); // Init MFRC522 card
  //---------------------------------------------
  connectToWiFi();
  GetCurrentNumber();
}

void GetCurrentNumber(){
  Serial.println("Getting number empty place");
//  String URLNumber = "http://192.168.1.19:81/smart-parking/show_current_number.php";
  String URLNumber = "http://smart-parking-pbl5.herokuapp.com/show_current_number.php";
  if(WiFi.isConnected()){
    WiFiClient client;
    HTTPClient http;    //Declare object of class HTTPClient
    
    //GET methode
    Link = URLNumber;
    http.begin(client,Link); //initiate HTTP request   //Specify content-type header
    int httpCode = http.GET();   //Send the request
    String payload = http.getString();    //Get the response payload
    Serial.println(Link);   //Print HTTP return code
    Serial.println(httpCode);   //Print HTTP return code
    Serial.println(payload);    //Print request response payload
    number_empty = payload;
  }
  
}


//************send the Card UID to the website*************
void SendCardID( long Card_uid ){
  Serial.println("Sending the Card ID");
  if(WiFi.isConnected()){
    WiFiClient client;
    HTTPClient http;    //Declare object of class HTTPClient
    //GET Data
    getData = "?card_uid=" + String(Card_uid) + "&device_token=" + String(device_token); // Add the Card ID to the GET array in order to send it
    //GET methode
    Link = URL + getData;
    http.begin(client,Link); //initiate HTTP request   //Specify content-type header
    int httpCode = http.GET();   //Send the request
    String payload = http.getString();    //Get the response payload
    Serial.println(Link);   //Print HTTP return code
    Serial.println(httpCode);   //Print HTTP return code
    Serial.println(Card_uid);     //Print Card ID
    Serial.println(payload);    //Print request response payload

  
    
    if (httpCode == 200) {
      if (payload.substring(0, 5) == "login") {
        String user_name = payload.substring(5);
        String number = payload.substring(8,9);
        myservo1.write(120);
        delay (2000);
        myservo1.write(0);
    //  Serial.println(user_name);
        number_empty = number;
        

      }
      else if (payload.substring(0, 6) == "logout") {
        String user_name = payload.substring(6);
        String number = payload.substring(9,10);
        myservo1.write(120);
        delay (2000);
        myservo1.write(0);
    //  Serial.println(user_name);
        number_empty = number;
      }
      else if (payload == "succesful") {

      }
      else if (payload == "available") {

      }
      delay(100);
      http.end();  //Close connection
    }
  }
}
//************************************************************************
void loop() {
  lcd.setCursor(1,0);
  lcd.print("Smart Parking");
  lcd.setCursor(2,1);
  lcd.print("Have slot: ");
  lcd.print(number_empty);
  //check if there's a connection to Wi-Fi or not
  if(!WiFi.isConnected()){
    connectToWiFi();    //Retry to connect to Wi-Fi
  }
  delay(50);
    if ( mfrc522.PICC_IsNewCardPresent()){
        if ( mfrc522.PICC_ReadCardSerial()){
          long CardID=0;
          for (byte i = 0; i < mfrc522.uid.size; i++){
            CardID=((CardID+mfrc522.uid.uidByte[i])*10);
          }
          SendCardID(CardID);
        }
    }   
    
    delay(1000);
  }



//=======================================================================
