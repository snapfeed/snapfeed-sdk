# Snapfeed Example  
  
This project uses the default Flutter sample project and adds the Snapfeed widget to enable interactive user feedback - luckily that's easy as 1-2-3 🎉

## What are the differences from the official Flutter sample?

Inside `main.dart` the default `MaterialApp` is now a child of `Snapfeed`. It's important that Snapfeed sits at the root of your application for it to function properly.

We also added an `IconButton` as the only action to the `AppBar` which serves as the trigger for the feedback routine. In its callback it calls `Snapfeed.of(context).startFeedback()` to launch Snapfeed.

## Running the Sample

1. Create a new Snapfeed project on [snapfeed.dev](https://snapfeed.dev).
2. Make sure to add your own API credentials to the `Snapfeed` widget inside `main.dart`.
3. Run the sample by typing `flutter run` into a console window inside the `example` folder.
4. Inside the sample app, tap the `?` button on the top right to launch Snapfeed.
5. Get creative and write / draw your first feedback 🖌
