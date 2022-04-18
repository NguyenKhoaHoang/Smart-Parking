//*******************************libraries********************************
//RFID-----------------------------
#include <SPI.h>
#include <MFRC522.h>
#include <SoftwareSerial.h>
#include <Servo.h> //includes the servo library
//NodeMCU--------------------------
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
//************************************************************************
#define SS_PIN  D2  //D2
#define RST_PIN D1  //D1
#define ServoPort D4 
Servo myservo1;
//************************************************************************
MFRC522 mfrc522(SS_PIN, RST_PIN); // Create MFRC522 instance.
//************************************************************************
/* Set these to your desired credentials. */
const char *ssid = "404 Not Found";
const char *password = "244466666";
const char* device_token  = "8ceb36c810343326";
//************************************************************************
String URL = "http://192.168.1.114:81//smart-parking/getdata.php"; //computer IP or the server domain
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
  myservo1.attach(ServoPort);
  myservo1.write(0);
  //delay(1000);
  Serial.begin(115200);
  delay(100);
  SPI.begin();  // Init SPI bus
  mfrc522.PCD_Init(); // Init MFRC522 card
  //---------------------------------------------
  connectToWiFi();
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
        myservo1.write(120);
        delay (2000);
        myservo1.write(0);
    //  Serial.println(user_name);

      }
      else if (payload.substring(0, 6) == "logout") {
        String user_name = payload.substring(6);
        myservo1.write(120);
        delay (2000);
        myservo1.write(0);
    //  Serial.println(user_name);
        
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
