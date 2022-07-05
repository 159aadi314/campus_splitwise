# Campus_Splitwise

App to handle group expenses. Inspired from Splitwise.

# Table of contents

- [Introduction](#introduction)
- [Technologies](#technologies)
- [Features](#features)
- [Launch](#launch)
- [Project Status](#project-status)
- [Sources and Inspirations](#sources-and-inspirations)
<!-- -   [License](#license) -->

# Introduction

 <!-- Talk about the idea behind this app  -->

# Technologies

- [flutter](https://docs.flutter.dev/get-started/)
  <!-- list of some important flutter plugins, if any -->

- [firebase]()
  <!-- list of firebase services we used -->

# Features

## Friends list

- From the friends' list, you can add IOUs for something that friend paid for. It will be cancelled out when that friend adds IOU for you.

- Expenses shared between friends (not in groups) have no cycle reduction or path simplification.

- Add friends by entering their email.

## Groups

- Create a group by adding members from your friend list. Then the users within the group can add contributions, to be splitted equally among the group.

- **Path simplification** : Members of a group are not prompted to pay every single person who contributed to the group, rather the app pair users who paid below average to users who paid above average using a greedy strategy. This computed value is displayed to users, reducing the number of total transactions.
- Settle Up : Only accessible by group owner, on activated, all contributions of the group is set to zero and any remaining IOUs are sent to each users' friends list.

# Launch

- configure firebase:
<!-- complete this  -->

# Project Status

Current in development.

# Sources and Inspirations

<!-- any specific tutorials that you'd like to credit -->
