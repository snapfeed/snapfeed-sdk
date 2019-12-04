<p align="center">  
    <img src="https://user-images.githubusercontent.com/11478053/69978974-adb12200-152d-11ea-9f6e-9f6a55586707.png" alt="Snapfeed Logo"/>  
</p>
  
# Snapfeed Beta  
  
Hey there and thanks for checking out the Snapfeed Beta 🎉 Snapfeed is probably the easiest and most convenient way to capture in-app user feedback, wishes, ratings and much more. The SDK is completely written in Dart and runs on Android, iOS, Desktop and the Web. For more info, head over to [snapfeed.dev](https://snapfeed.dev). 
  
## Getting Started  
  
In order to get started, you need to create an account at [snapfeed.dev](https://snapfeed.dev) - you do this by simply signing in with a valid Google account.

### Creating a new project

<img alt="Step 1" src="https://user-images.githubusercontent.com/11478053/69979050-d5a08580-152d-11ea-8140-85df7d2a4f8a.png">

After signing in you should land on the projects screen where you can find all your current Snapfeed projects. Click on **Create new project** and choose a name for it. Be creative. You can use whatever name you want 🦄

Now your new project has been created! On the **Settings** page you will find your API credentials, namely the project id and secret. You will need to provide those for configuring the SDK.

<img alt="Step2" src="https://user-images.githubusercontent.com/11478053/69979202-26b07980-152e-11ea-9fcb-aa4780d92347.png">

### Setting up your Flutter project

After successfully creating a new project in the Snapfeed admin console it's time to add Snapfeed to your app. Simply open your `pubspec.yaml` file and add the current version of Snapfeed as a dependency, e.g. `snapfeed: 0.1.0`. Make sure to get the newest version.

Now get all pub packages by clicking on `Packages get` in your IDE or executing `flutter packages get` inside your Flutter project.

Head over to the main entry point of your app which most likely resides inside `main.dart`. In here wrap your root widget  inside a `Snapfeed` widget and provide your API credentials as parameters. That was already the hard part 🙌

```
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Snapfeed(
      projectId: "YOUR-PROJECT-ID",
      secret: "YOUR-SECRET",
      child: MaterialApp(
        title: 'Flutter Demo',
        home: ...
      ),
    );
  }  
}
```

Now you can call `Snapfeed.of(context).startFeedback()` from anywhere inside your app to start the feedback process!

### Android / iOS specific setup

Snapfeed is by design written in Dart and thus does not have any native dependencies. However, when running on Android it needs the internet permission (for sending user feedback back to you). If you already use Flutter in production, chances are quite high that you already added the internet permission to the manifest - if not, add the following line to the `AndroidManifest.xml` in your Android project folder:

```
<manifest ...>
 <uses-permission android:name="android.permission.INTERNET" />
 <application ...
</manifest>
```

That's it!
  
## License  
  
Snapfeed is released under the [Attribution Assurance License](https://opensource.org/licenses/AAL). See [LICENSE](LICENSE) for details.