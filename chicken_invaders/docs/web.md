# Web Support

This game is fully compatible with Web.

Build for web using the following command:

```shell
flutter build web
```

Run server (quick and easy) - development only:

```shell
python -m http.server 8000
```

or:

```shell
npx http-server
```

Run the above commands from `build\web` directory.

You can then expose the web server by using [ngrok](https://ngrok.com/):

```shell
ngrok http 8000
```

This will create an url similar to https://777f-82-77-65-217.ngrok-free.app/ which will point to your local instance of the application.