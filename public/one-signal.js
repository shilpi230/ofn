var latitude = "";
var longitude = "";
var phone = "";
var email = "";
var response;

//getUserData();

function getLocation() {

  if (navigator.geolocation) {
    console.log('Geolocation is supported!');
    //alert("getLocation1");

    navigator.geolocation.getCurrentPosition(showPosition, handleError);

    function handleError(error) {
      //Handle Errors
      switch (error.code) {
        case error.PERMISSION_DENIED:
          console.log("User denied the request for Geolocation.");
          break;
        case error.POSITION_UNAVAILABLE:
          console.log("Location information is unavailable.");
          break;
        case error.TIMEOUT:
          console.log("The request to get user location timed out.");
          break;
        case error.UNKNOWN_ERROR:
          console.log("An unknown error occurred.");
          break;
      }
    }

    //alert("getLocation2");
  } else {
    console.log("Geolocation is not supported by this browser.");
  }

}

function showPosition(position) {
  // alert("showPosition");
  this.latitude = position.coords.latitude;
  this.longitude = position.coords.longitude;
  //alert(this.latitude);
}

function getUserData() {
  //  this.email  = prompt("Please enter your Email Id", "email@xyz.com");
  //this.phone  = prompt("Please enter your Phone Number", "xxx-xxx-xxxx");
  // alert("getUserData");

  $.msgBox({
    type: "prompt",
    title: "Please Enter Your Info",
    inputs: [{
        header: "Email Id",
        type: "text",
        name: "emailId"
      },
      {
        header: "Phone Number",
        type: "text",
        name: "phoneNo"
      }
    ],
    buttons: [{
      value: "OK"
    }, {
      value: "Cancel"
    }],
    success: function(result, values) {
      var v = result + " has been clicked\n" + values;
      var emailValue;
      var phoneValue;
      $(values).each(function(index, input) {
        if (index == 0)
          emailValue = input.value;
        if (index == 1)
          phoneValue = input.value;

      });
      //alert(emailValue + " * " + phoneValue);
      assignValues(emailValue, phoneValue);
      sendDataTooneSignal();
    }
  });

}

function assignValues(emailValue, phoneValue) {
  //alert(emailValue + " ## " + phoneValue);
  this.email = emailValue;
  this.phone = phoneValue;
}


function fetchIP(callback) {
  window.setTimeout(function() {
    $.get("https://ipinfo.io", function(response) {
      callback(response);
    }, "jsonp");
  }, 2000);
}

function subscribe() {
  OneSignal.push(["registerForPushNotifications"]);
  event.preventDefault();
}

function sendData(response) {
  this.response = response;

  var OneSignal = window.OneSignal || [];

  OneSignal.push(["init", {
    appId: "c68e1e56-6658-4fa0-8296-284ace80a4e6",
    autoRegister: false,
    notifyButton: {
      enable: true /* Set to false to hide */
    },

    welcomeNotification: {
      "title": "My CUSTOM Title",
      "message": "Thanks for subscribing! Enter CUSTOM message here.",
    }
  }]);

  OneSignal.push(function() {

    OneSignal.isPushNotificationsEnabled().then(function(isEnabled) {
      if (isEnabled) { //if the user is already subscribed
        console.log("Push notifications are enabled!");

        /*OneSignal.sendSelfNotification(
          "Enter CUSTOM Title here",

          "Enter CUSTOM Message here!!!.");
        */
      } else {
        console.log("Push notifications are not enabled yet.");
        OneSignal.showHttpPrompt();
        //if (Notification.permission === "granted") {
        window.setTimeout(function() {
          getLocation(); //Fetch User's Location

        }, 5000);

        window.setTimeout(function() {
          getUserData(); //Fetch User's Data
        }, 7000);
        //}
      }

    });
  });
}

function sendDataTooneSignal() {

  OneSignal.sendTags({
    IP: response.ip,
    Country: this.response.country,
    Latitude: this.latitude,
    Longitude: this.longitude,
    Email: this.email,
    Phone: this.phone
  });

}

fetchIP(sendData);
