# Neighborly flutter app

These notes were created to ensure the continuity of the application's development.

It is not intended to contain all the answers, but try to include the answers here to all the questions that the document was unable to answer, in order to improve the lives of the team that needs to deal with future adjustments.

#### Some links
- [Figma](https://www.figma.com/design/xRXpvwJz0aQgxroUE2gEnN/App-design?t=xLEF3whwCxjKw5H7-0)
- [Git Repo](https://github.com/BharatShukla30/)
  
---
<br /><br />

## 🧩 Clean Architecture
Clean Architecture is an approach to designing software systems that emphasizes organizing code into well-defined layers, making the software more modular, testable, and easy to maintain. Additionally, Clean Architecture promotes the application of principles such as the Single Responsibility Principle and the Dependency Inversion Principle to create flexible and highly cohesive systems.

<br />
<p align="center">
  <img src="https://github.com/moacirjacomin/vakinha_backoffice_web/blob/main/prints/clean-arch-circles.png?raw=true" width="750" title="CLEAN arch">
</p>

More about clean arch: 
- [A good article on the topic](https://betterprogramming.pub/the-clean-architecture-beginners-guide-e4b7058c1165)
- [Another good article](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
 
---
<br /><br />


## 🏷️ Modules and Layer Organization
The idea behind using these approaches may seem initially complicated and may spread code across hundreds of files and folders. However, it makes sense for applications with the following requirements:

- Scalability: should be ready for new features.  
- Testing: should make easy to automate tests.
- Teams: should be easy to manage several groups of people changing the same code base.
- Reuse: should be simple reusing modules from other projects (e.g., shared, authentication, profile).
- MicroApp: should facilitates the conversion to micro-apps, where each module can become a package.


Modules/Functionalities / Layer Folders / Shared Module

<br />
<p align="left">
  <img src="https://github.com/moacirjacomin/vakinha_backoffice_web/blob/main/prints/ARC01-folders.png?raw=true"  title="CLEAN arch"> 
  <img src="https://github.com/moacirjacomin/vakinha_backoffice_web/blob/main/prints/ARC02-folders.png?raw=true"  title="CLEAN arch"> 
  <img src="https://github.com/moacirjacomin/vakinha_backoffice_web/blob/main/prints/ARC04-folders.png?raw=true"  title="CLEAN arch"> 
</p>

### Creating something new? 
Have in mind that to create some new module or screen, you need to check: 
- [ ] Add the block to BLOC provider on main.dart 
- [ ] Add dependencies to be injected in dependency_injection.dart
- [ ] Add the route for this new page on \core\routes\routes.dart
Note: any change in this 3 files will reflect in the app debugger until a stop/start the app. 
---
<br /><br /><br />

### 💻 Control Panel
Some links to jump to the console to solve problems
- [Firebase Project](https://console.firebase.google.com/u/0/project/neighborly-423215/)
- [Google Cloud Project](https://console.cloud.google.com/iam-admin/settings?project=neighborly-423215)
---
<br /><br /><br />


## 📅 Data/Hour helpers
There is a folder with the helpers (/lib/core/utils)
```dart
// function                                                    input/output                 
simplifyISOtimeString(String date):                      2024-08-01T02:30:00 ==> August 1, 2024 
simplifyISOtimeStringOnlyHour(String date)               2024-08-01T02:30:00 ==> 02:30 AM 
simplifyISOtimeStringStartEnd(dateStart, dateEnd) dates: 2024-08-01T02:30:00 ==> 01/08 - 02/08
```
---
<br /><br /><br />



## ✉️ Push Notifications
To check details about the notification process please take a look on the [PDF File](./Backend_Logic_Handling_Notifications.pdf). A message can refer to specific pages inside the app. 
Aside from a title and a message, the notification also has a data part that will have ONE of this options: 
```JSON
 { 
    "postId": "163", 
    "eventId": "668164e760dbe07a2fd9df5b", 
    "messageId": "668164e760dbe07a2fd9df5b", 
    "commentId": "668164e760dbe07a2fd9df5b",
    "userId": "669bfe2c8486500123a10754",
    "groupId": "668164e760dbe07a2fd9df5b",
    "userId": "669bfe2c8486500123a10754"
  },
```
One of the lines because depends on the event trigger, for example if it's about a event, the data will have the eventId. 

#### How to test?
It's possible to test, sending message to a specific user. To get the FCM token, check the logs on the app start. 
```dart
  ... currentToken= fG3HDysiQD2HeycGWihjk-:APA91bFFIEgWbkuGbJSLAx1-J-rgaMHhmZLU_ccCp5EHK4d_WEk64CqhYnDxcxqFWDjy3BNQTx8RR_ihVSnlU0aoixxpHZptS-4CmuIogvkqxpSZET9Wnhvngs_uTANmeC_-W2ODyFRe
```
Then access the [FCM console](https://console.firebase.google.com/u/0/project/neighborly-423215/notification/compose?hl=pt-br&campaignId=5825931153988893231) and add the token to be abble to sendo a test message. 

#### Where on the code?
To check the code that does the switch on receiving a notification, try to look for this funcions on the notification module folder:
```dart
  // the brain
  LocaleNotificationManager

  // the config that connect the app to FCM/Firebase project: 
  FCMConfig 

  // helper:
  MessageHandlerHelper
```
The FCM message payload looks like this:
```JSON
  {
    "senderId":null,
    "category":null,
    "collapseKey":"com.example.neighborly_flutter_app",
    "contentAvailable":false,
    "data":{
        "userId":"669bfe2c8486500123a10754",
        "order":"11111"
    },
    "from":"805628551035",
    "messageId":"0:1723801798121711%676aaa4f676aaa4f",
    "messageType":null,
    "mutableContent":false,
    "notification":{
        "title":"test",
        "titleLocArgs":[
          
        ],
        "titleLocKey":null,
        "body":"test",
        "bodyLocArgs":[
          
        ],
        "bodyLocKey":null,
        "android":{
          "channelId":null,
          "clickAction":null,
          "color":null,
          "count":null,
          "imageUrl":null,
          "link":null,
          "priority":0,
          "smallIcon":null,
          "sound":null,
          "ticker":null,
          "tag":"campaign_collapse_key_2037540593551237731",
          "visibility":0
        },
        "apple":null,
        "web":null
    },
    "sentTime":1723801798112,
    "threadId":null,
    "ttl":2419200
  }

```
---
<br /><br /><br />



## 🔑 App Android key and SHA1 
The key is the only way to google store knows the app upload is really the original. 
So take care and make copies of the file \android\app\keystore\neighborly-keystore.jks 

#### App key info:
```console



```
---
<br /><br /><br />



## 📱 To create the APK
Small instructions to generate the APK
```console 
    // apk easy to send and install. To release on the store
    // the appbundle is the option, smaller
    flutter build apk --release
    flutter build appbundle --release

    // where the files goes
    \build\app\outputs\bundle\release 

```
---
<br /><br /><br />


## ⁉️ Where
Here some comments about where to find some key points of the app code. 

#### Where are the colors? 
The color are defined at: lib\core\theme\colors.dart

#### Where are the list content? 
The app for now has some list that maybe in the future can be get from the API to be mor dinamic. For now the list content are defined at: 
\lib\core\constants\constants.dart
The most of this constants are used to define the dropDown option on the forms, e.g registering a event or profile gender, etc. 


#### Where are the navigation routes? 
The routes are defined at:  \lib\core\routes\routes.dart

```dart
  // example of a simple route with id as parameter            
      GoRoute(
        path: '/chat/private/:roomId',
        builder: (context, state) => ChatPrivateScreen(
          roomId: state.pathParameters["roomId"] as String,
          room: state.extra as ChatRoomModel,
        ),
      ),

  // example of a more complex router call definition
      GoRoute(
        path: '/post-detail/:postId/:isPost/:userId',
        name: RouteConstants.postDetailScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          final String postId = state.pathParameters['postId']!;
          final bool isPost = state.pathParameters['isPost'] == 'true';
          final String userId = state.pathParameters['userId']!;
          return PostDetailScreen(
            postId: postId,
            isPost: isPost,
            userId: userId,
          );
        },
      ),
  // how to call a route:
    context.push('/notifications');

  // how to call a route without the context
    router.push('/userProfileScreen/${messageData['userId']}');
```
---
<br /><br /><br />

## 👩‍🏫 Fake Avatar
Sometimes we need quick links to test avatar, follow some links or ways to do it:
```Dart
  // this one will create random color with letters from the mais parameter (e.g jack black ==> JB):
  'https://eu.ui-avatars.com/api/?name=${json['name']}&background=random&rounded=true',

  // some avatar links
  https://moacir.net/avatars/badge-friend01.png
  https://moacir.net/avatars/self-confidence.png
  https://xsgames.co/randomusers/avatar.php?g=male
  https://xsgames.co/randomusers/avatar.php?g=female
  'https://moacir.net/avatars/46.jpg',  // f
  'https://moacir.net/avatars/10.jpg',    // f
  'https://moacir.net/avatars/16.jpg',    // f
  'https://moacir.net/avatars/34.jpg',
  'https://moacir.net/avatars/40.jpg',
  'https://moacir.net/avatars/77.jpg',
  'https://moacir.net/avatars/none.png', 
      
```
---
<br /><br /><br />