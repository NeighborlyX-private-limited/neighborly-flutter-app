const kBaseUrl = "https://prod.neighborly.in/api";
const kBaseUrlNotification = "https://prod.neighborly.in/notification";

// const kBaseUrl = "https://dev.neighborly.in/api";
// const kBaseUrlNotification = "https://dev.neighborly.in/notification";
const kBaseSocketUrl = "ws://54.90.230.2:3001";
const double kMaxRadius = 100;
const double kMinRadius = 1;

const List<String> kReportReasons = [
  'Inappropriate content',
  'Spam',
  'Harassment or hate speech',
  'Violence or dangerous organizations',
  'Intellectual property violation',
];

const List<String> kCityList = ['Delhi', 'Noida', 'Gurugram'];
const List<String> kLocationList = [
  'Agra',
  'Ahmedabad',
  'Allahabad',
  'Amritsar',
  'Aurangabad',
  'Bangalore',
  'Bhopal',
  'Chandigarh',
  'Chennai',
  'Coimbatore',
  'Delhi',
  'Dhanbad',
  'Faridabad',
  'Ghaziabad',
  'Guwahati',
  'Gwalior',
  'Howrah',
  'Hyderabad',
  'Indore',
  'Jaipur',
  'Jabalpur',
  'Jodhpur',
  'Kalyan-Dombivli',
  'Kanpur',
  'Kolkata',
  'Kota',
  'Ludhiana',
  'Lucknow',
  'Madurai',
  'Meerut',
  'Mumbai',
  'Nagpur',
  'Nashik',
  'Navi Mumbai',
  'Patna',
  'Pimpri-Chinchwad',
  'Pune',
  'Raipur',
  'Rajkot',
  'Ranchi',
  'Srinagar',
  'Solapur',
  'Surat',
  'Thane',
  'Vadodara',
  'Varanasi',
  'Vasai-Virar',
  'Vijayawada',
  'Visakhapatnam',
  'Jaipur'
];

const List<String> kEventCategories = ['Nerd', 'Hackaton', 'Music', 'Food'];

const List<String> kGender = ['', 'Female', 'Male'];

List<String> kHoursOfDay = [
  "12:00 AM",
  "01:00 AM",
  "02:00 AM",
  "03:00 AM",
  "04:00 AM",
  "05:00 AM",
  "06:00 AM",
  "07:00 AM",
  "08:00 AM",
  "09:00 AM",
  "10:00 AM",
  "11:00 AM",
  "12:00 PM",
  "01:00 PM",
  "02:00 PM",
  "03:00 PM",
  "04:00 PM",
  "05:00 PM",
  "06:00 PM",
  "07:00 PM",
  "08:00 PM",
  "09:00 PM",
  "10:00 PM",
  "11:00 PM"
];
