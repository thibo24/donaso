# donaso

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Config of google maps api : 
you must register on google maps to get an api keys.
you create a new application then you create a new project we only need google maps basic fonctionalities so it should be free.

Database 
as a database we used Mangodb 
table : 
![image](https://github.com/thibo24/donaso/assets/98901782/edd34e30-d8fc-4667-a1b0-7b81722aebce)

with item looking like 
admin :
{"_id":{"$oid":"64786e4375e235f4022eeb76"},"username":"admin","password":"123456789","__v":{"$numberInt":"0"}}
markers: 
{"_id":{"$oid":"649513ead18885c3c4b21a35"},"coordinates":{"type":"Point","coordinates":[{"$numberDouble":"-122.087629"},{"$numberDouble":"37.410883"}]},"type":"Recycling Bin","name":"Location 1","description":"Description 1"}
users: 
{"_id":{"$oid":"64a2809d349d7cf128dfaf63"},"username":"thibo1","password":"$2a$10$/NnBaxge0bbY4Kj0iW49le47l74KqGmoVNksi2dtzxPp6f45doR1G","email":"ttttttt@gmail.com","phone":"0000000000","image":"default.png","points":{"$numberInt":"13"}}
wastes: 
{"_id":{"$oid":"647878abad9ee36bc84f2676"},"name":"cardboard","description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit.","image":"cardboard.png","type":"yellow","__v":{"$numberInt":"0"}}



