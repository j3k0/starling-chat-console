# starling-chat-console
A chat console for starling

A starling/feathers based chat console that can be integrated within a mobile application (AIR) and Facebook (Flash), developed in pure actionscript.

**The below isn't implemented, it's only a specification.**

### Usage

1. Clone the repo.
1. Add the repo's `src/` folder to your project's source-path.
1. Implement your own `ChatServer`.
1. Instanciate the ChatConsole and add it to your scene.

### User Interface

![User Interface](doc/chat-spec.jpg)

Chat console appears from the right hand side. it's possible to either slide it to the right, close it by clicking "close" or by clicking outside the chat console.

Game is still visible on the left hand side. The total width of the visible size may vary, depending on the device size (tablet or phone). However, the chat console should capture events made on the game part when it's visible. When the user clicks on the outside of the console, the console hides itself.

### Initial API

```actionscript
package fovea.chat;

public class ChatMessage {

  // user that sent this message
  public var username:String;

  // URL of the avatar image (always a square)
  public var avatarURL:String;

  // message text
  public var message:String;

  // current state of the message (see const below)
  public var state:int;

  public static const STATE_IN_PROGRESS:int = 0;
  public static const STATE_SUCESS:int = 1;
  public static const STATE_FAILED:int = 2;
}

public interface IChatServer {

  // initiate sending a message
  function send(message:String):void;

  // return the list of messages on the chat room
  function getData():Vector<ChatMessage>;

  // listeners functions will be called without arguments
  // when data is updated.
  function addListener(f:Function):void;
  function removeListener(f:Function):void;
}

// The IChatTheme interface allow to define your own theme for the ChatConsole.
// It's a collection of factory methods for each basic elements it uses.
// (to be defined while implementing the ChatConsole)
public interface IChatTheme {

  // example call 1
  function createTextField(prompt:String):TextField;

  // example call 2
  function getBackgroundColor():uint;

  // ...
}

public class ChatConsole extends Sprite {

  public function ChatConsole(server:IChatServer, theme:IChatTheme);

  // make the console appear on screen (animated from right)
  public function show():void;

  // make the console disappear from screen (animated to the right)
  public function hide():void;
}
```

### System Messages

The chat console can also display system message. Such messages will have a empty `username` and should have a special presentation (see screenshot on top).
