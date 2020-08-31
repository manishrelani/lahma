import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

int versionCode = 1;
String appVersion = "1.0.0";

Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
DateFormat formatterFddMMM = DateFormat('dd-MMM');
DateFormat formatterFdd = DateFormat('dd');
DateFormat formatterFddMMMyyyy = DateFormat('dd-MMM-yyyy');
DateFormat formatterFWeekday = DateFormat('EEEE');
DateFormat formatterFyyyyMMdd = DateFormat('yyyy-MM-dd');
Duration timeOutDuration = Duration(seconds: 15);

enum ButtonType { positiveButton, negativeButton }

class Constants {
  static const timeOutInSeconds = 61;

  /*Alert Title*/

  static const String titlename = '123 Vamos';

  static const String reservationCancel = 'Reservation Cancel';

  static const String close = 'Close ';

  static const String submitRatind = 'Submit Ratting ';

  static const String currentTrip = 'Current Trip ';

  static const String next = 'Next';

  static const String viewCancelReason = 'View Reason';

  static const String acceptReserverCondition = 'You have to agree to the terms and conditions';

  static const String stopTimeInMinutes = 'Stop time (in minutes)';

  static const String whyDoYouWantToCancel = 'Why do you want to cancel your trip?';

  static const String onlyFreeSeat= 'only free seats ';

  static const String reasonCategory= 'Reason category';
  static const String cancel_reason= 'Cancel reason';

  static const String rattingAndreview= 'Ratting & Review';

  static const String notApplied = 'Not Applied';

  static const String ratting = 'Ratting';

  static const String review = 'Review';

  static const String verified = 'Verified';

  static const String tripDateError = "Start time can't empty";

  static const String appliedNotApprovedYet = 'Applied not approved yet';

  static const String yourIDRejected = 'Your identity is not verified by the administrator.';

  static const String whyVerifyYourIdentityDocument = 'Why verify your identity document?';

  static const String becauseMemberOfOurCommunity = 'Because members of our community will have more confidence to travel with people who verify your identity. Do not worry! We will never use your identity document publicly on the platform.';

  static const String whatIsYourIdentityDocument = 'What is your identity document?';

  static const String numberOfSeats = 'Number of seats';

  static const String IdCard = 'Identification card';

  static const String passport = 'Passport';

  static const String pleaseSendThePhotoOfYour = 'Please send the photo of your identity document.It must be readable, clear and well focused.';

  static const String intervalTime = 'Interval time';

  static const String selectReason = 'Select reason';

  static const String accountType = 'Select Account Type';

  static const String saving = 'Saving Account';

  static const String current = 'Current Account';

  static const String reservationProcess = 'Reservation process';

  static const String immediateBookingTrip = 'IMMEDIATE';

  static const String confirmReservation = 'CONFIRM IN 6 HOURS';

  static const String areYouFlexiableWithTime = 'Are you flexible with time?';

  static const String yes = 'Yes';

  static const String price = 'Price';

  static const String nextStop = 'Next Stop';

  static const String distance = 'Distance ';

  static const String vehicleApprovalApprovedMessage = 'Your request has been approved.';

  static const String vehicleApprovalDecliendMessage = 'Your request is decliend.';

  static const String vehicleApprovalForWaitMessage = 'Your request is under progress. Plase wait 48 hours for admin approval.';

  static const String putYourPriceHere = 'Enter your price here ';

  static const String recommendedPrice = 'Recommended price ';

 // static const String stopTimeInMinutes = 'Stop time (in minutes) ';

  static const String duration = 'Duration';

  static const String newPriceError = 'New price greater then old recommended';


  static const String doNot = 'DO NOT';

  static const String detailsOfTheTrip = 'Details of the trip';

  static const String details = 'Details';


  static const String acceptGeneralCondition5 = ' . I certify owning a driver\'s license and valid insurance.';

  static const String acceptGeneralCondition4 = 'Confidentiality Policy';

  static const String acceptGeneralCondition3 = 'and the';

  static const String acceptGeneralCondition2 = ' General Conditions  ';

  static const String acceptGeneralCondition1 = 'I accept the';


  static const String detailsOfTheTripHint = 'Dar precisiónes sobre el viaje para no recibir demasiados preguntas.Por ejemplo, "Saldremos de la puerta A, estacionamiento Unicentro en Medellín" o "Acepto solo maletas pequeñas"';

  static const String addVehicalPhoto = 'Add Vehical Photo';

  static const String tripDetail = 'Trip Details';

  static const String save = 'Save';

  static const String inWhichCitiesWillItStop = 'In which cities will it stop?';

  static const String firstName = 'First Name';

  static const String addNewStop = 'Add New Stop';

  static const String phoneCode = 'Code';

  static const String messages = 'Messages';

  static const String payment = 'Payment';

  static const String lastName = 'Last Name';

  static const String confirmPassword = 'Confirm Password';

  static const String password = 'Password';

  static const String appTitlesub = '123 Come on';

  static const String hour = ' Hour';

  static const String color  = 'Color';

  static const String detailsOfTheTrips = 'Details of the trip :';

  static const String acceptTheGeneralCondition = 'I accept the general conditions and the confidentiality precepts';


  static const String send = 'Send';

  static const String seat = ' Seats ';

  static const String startEnd = 'Start - End ';

  static const String stop = ' Stop ';

  static const String idVerified = 'ID Verified';

  static const String driverDetails = 'Driver Details';

  static const String howManySeatesDo = 'How many seats do you want to reserve? ';

  static const String from = 'From';

  static const String immediateBooking = 'Immediate booking';

  static const String to = 'To';

  static const String reserve = 'Reserve';

  static const String searchATrip = 'Search A Trip';

  static const String date = 'Date & Time';

  static const String searchTrip = 'Search Trip';

  static const String typeYourMessagehere = 'Type your message here';

  static const String paymentDetailsSubText = 'To receive a payment';

  static const String paymentDetailsinfo = 'Register the details of a bank account so you can receive the payment when you share a trip.';

  static const String paymentDetailsTerms = 'The transfer order will be made to the bank account 5 days after the trip.';

  static const String accountNumber = 'Account Number';

  static const String typeOfAccount = 'Type Of Account';

  static const String nameOfBank = 'Name Of Bank';

  static const String idNumber = 'ID Number';

  static const String start = 'Start';

  static const String end = 'End';

  static const String location = 'Location';

  static const String accountHolderName = 'Account Holder Name';

  static const String currancy = '\$';

  static const String cancel = 'Cancel';

  static const String feedbackRating = 'Feedback rating';

  static const String totalSeat = 'Total Seats';

  static const String noOfSeatBook = 'No. of seat book - ';

  static const String paidAmount = 'Paid';

  static const String amount = 'Amount';

  static const String status = 'Status';

  static const String pricePerSeat = 'Price per seat';

  static const String driverName = 'Driver Name';

  static const String vehicleBrand = 'Vehicle brand';

  static const String licenseNumber = 'License number';

  static const String vehicleModel = 'Vehicle model';

  static const String vehicleColor = 'Vehicle color';

  static const String vehicleLicensePlateNumber = 'Vehicle license plate number (without spaces)';

  static const String drivingExperience= 'Driving experience (in years)';

  static const String dateAndTime = 'Date & Time';

  static const String accept = 'Accept';

  static const String reject = 'Reject';

  static const String update = 'Update';

  static const String upload = 'Upload';

  static const String emailCheck = 'Email checked ';

  static const String phoneCheck = 'Verify phone number';

  static const String verify = 'Verify';


  static const String verificationPhoneText = 'Registering your phone number, it is important to organize the trip with the other passengers';

  static const String checkDocument = 'Verify identity document';

  static const String verificationDocumentText = 'This way the other travelers will have more confidence!';

  static const String uploadDocument = 'Uplaod document';

  static const String verificationTermsAndCondition = 'The information received by 123Vamos is used to create and verify your account, so it is mandatory. By completing . this information you are accepting our General Conditions. To know more you can consult our Confidentiality Policies';

  static const String verificationText = 'We want to build trust in the members of this community, so please verify your information. This way you will find more people to share your trips!';

  static const String photoInfo = 'PNG, JPEG or GIF, Maximum 3 MB. (Upload a clear and bright photo, with only one face and no sunglasses to identify yourself well)';

  static const String addPhoto = 'Add a Photo';

  static const String selectDob = 'Select Date of Birth';

  static const String aboutYourSelf = 'About your self';

  static const String persnoalInfo = 'Don\'t put your phone number here! Introduce yourself briefly (for example, what do you do in your spare time? Why are you a nice person to travel? Etc ...")';

  static const String alertTitle = "Alert";

  static const String chagePassword = "Change Password";

  static const String homeScreenTitle = "Your rides";

  static const String searchForTrip = "Search for trip";

  static const String personalInformation = "Personal Information";

  static const String verification = "Verification";

  static const String vehical = "Vehical";

  static const String postTrips = "Post Trips";

  static const String bookingRequest = "Booking Request";

  static const String completedTrips = "Completed Trips";

  static const String reservations = "Reservations";

  static const String currentReservation = "Current Reservations";

  static const String reservationHistory = "Reservation History";

  static const String paymentDetails = "Payment Details";

  static const String postATrip = "Post a trip";

  static const String updateTrip = "Update trip";

  static const String uploadImage = "Please upload Image";


  static const String notYetMember = "Not a member yet ? SignUp";

  static const String termsAndConditions = "By clicking on the Connect with Facebook button or when you sign up with your email, you accept the Terms and Conditions of Use and the Privacy Policy.";

  static const String facebookSignUpSubtitle = "Sign up in a few seconds with Facebook";

  static const String logIn = "LogIn ";

  static const String or = " OR ";

  static const String faceBookSubtitle = "Login in a few seconds with Facebook ";

  static const String signUp = "SignUp";

  static const String appDialog = "A new community to share your trips in Colombia.";
  //add movies

  static const String dashboard =  "Dashboard";

  static const String home ="Home";

  static const String Paid = "Paid";

  static const String cancelByUser = "Cancel by user";

  static const String cancelByDrive = "Cancel by drive";

  static const String claimAndRefund = "claim and refund";

  static const String back = "Back";

  static const String Pending = "Pending";


  static const String welcome = "Welcome";

  static const String submit = "Submit";

  static const String negativeButtonText = "Cancel";

  static const String positiveButtonText = "Ok";

  static const String notConnected = "No Internet ! ";

  static const String tryAgain = "Try Again ! ";

  static const String timeOutMessage = "Timeout !\n Please check if you have good internet connection!\n Try Again";

  static const String errorMessage =
      "Something Went Wrong !\n Please check if you have good internet connection!\n Try Again";

  static const String somethingWentWrong = "Something Went Wrong!";

  static const String wip = "Work in Progess";

  static const String noData = "No Data";

  static const String selectOption = 'Select Option';

  static const String exit = 'Exit';

  static const String enterEmail = "Email";

  static const String enterValidEmail = "Enter Valid Email";

  static const String enterValidMessage = "Enter Valid Message";

  static const String enterPassword = "Password";

  static const String fromWhichCityWillItLeave = "From which city will it leave??";

  static const String startTime = "Start time?";

  static const String whichCityWillYouTravelTo = "Which city will you travel to?";

  static const String forgotPassword = "Forgot Password";

  static const String enterValidPassword = "Enter Valid Password";

  static const String enterConfirmPassword = "Confirm Password";

  static const String enterValidConfirmPassword = "Password and Confirm Password should be identical";

  static const String enterPhone = "Enter Mobile Number";

  static const String yourPhoneNumber = "Your Mobile Number";

  static const String mobile = "Mobile Number";

  static const String enterOTP = "Enter OTP";

  static const String otp = 'OTP';

  static const String enterValidPhone = "Enter Valid Mobile Number";

  static const String emptyMessage = "Can't be Empty";

  static const String enterName = "Name";

  static const String login = 'Login';

  static const String reset = 'Reset';


  static const String profile = 'Profile';


  static const String logout = 'Logout';

  static const String paidto = "Paid:";







}