# Campus_Splitwise

App to handle shared expenses. Form groups or split with individual friends.

# Table of contents

- [Introduction](#introduction)
- [Technologies](#technologies)
- [Features with screenshots](#features)
- [Launch](#launch)
<!-- -   [License](#license) -->

# Introduction

 <!-- Talk about the idea behind this app  -->

# Technologies

- [Flutter](https://docs.flutter.dev/get-started/)
  <!-- list of some important flutter plugins, if any -->

- Firebase
    - [Firebase Authentication](https://firebase.google.com/docs/auth?authuser=0&hl=en)
    - [Cloud Firestore](https://firebase.google.com/docs/firestore?hl=en&authuser=0)

# Features

### Friends list

![image](https://user-images.githubusercontent.com/95305611/178106151-c18ee466-e4b7-41ef-89bb-b20f7042feb4.png)

- From the friends' list, you can add IOUs for something that the friend paid for. It will be cancelled out when that friend adds IOU for you.

- Search for friends quicky with the search bar.

![search friends](https://user-images.githubusercontent.com/95305611/178107300-889ea79e-01a9-43d7-85af-43d88bf9b2f9.gif)

- Add friends by entering their email. 

### Groups

- Easily create a group by adding members from your friend list. 

![group add friends](https://user-images.githubusercontent.com/95305611/178106444-f8e6ba84-7824-4613-8d0a-0fbba0f0a319.gif)

- Then the users within the group can add contributions, to be splitted equally among the group.

![group add contribution](https://user-images.githubusercontent.com/95305611/178107019-eded277a-17b4-43b6-b389-82b7863ef87c.gif)


- **Path simplification** : Members of a group are not prompted to pay every single person who contributed to the group, rather the app pair users who paid below average to users who paid above average using a greedy strategy. This computed value is displayed to users, reducing the number of total transactions.

<!-- Settle Up : Only accessible by group owner, on activated, all contributions of the group is set to zero and any remaining IOUs are sent to each users' friends list. -->

# Launch

- First configure firebase, then install dependencies with `flutter pub get`.

- Run with `flutter run`.

