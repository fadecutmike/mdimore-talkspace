# mdimore-talkspace
iOS Drawing application task

# Application Architecture
This application uses an MVVM approach with protocol/delegate and property observers for binding.

# Technical Approach
Inorder to implement multi colored brush strokes and variable line widths I used Core Data to store UIBezierPath Data via 'NSKeyedArchiver'. When the data is loaded, each previously saved brushstroke gets added to a CAShapeLayer and then added to a UIView underneath the interactive 'Canvas' that handles the drawing.

# Unimplemented Features

### Firebase/Firestore + Login   
I've used Firestore and Firebase extensively in my own Swift projects and also for production projects at work. I chose to go with Core Data for this project because I was concerned with serializing 'UIBezierPath' object data (Vector/geometry based representations of drawn brushstrokes). In order to get crisp graphics and to implement the 'Replay' functionality, these path objects were key. Firebase would have been a compelling option if I had a solid encode/decode strategy for the Path data.
