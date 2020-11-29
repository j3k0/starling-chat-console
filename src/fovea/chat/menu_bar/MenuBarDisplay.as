package fovea.chat.menu_bar
{
    
    CONFIG::MOBILE {
        import flash.text.ReturnKeyLabel;
    }

    import fovea.chat.ChatConsole;
    import fovea.chat.objects.MenuButton;

    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;
    import starling.events.Event;
    import starling.utils.Color;
    import feathers.controls.Button;

    /**
     * View for the Menu Bar. </br>
     * defines Menu Bar layout
     */
    public class MenuBarDisplay extends DisplayObjectContainer
    {
        /** the background of the object */
        private var _background:Quad;
        /** the mute button */
        private var _reportButton:Button;
        private var _blockButton:Button;
        private var _disableChatButton:Button;
        // force the text input to keep focus (fix issues with android)


        /**
         * Instantiates a MenuBar controller
         * @param backgroundColor:uint - Background color of the MenuBar
         * @param textboxColor:uint - Background color of the MenuBar TextArea
         */
        public function MenuBarDisplay(backgroundColor:uint, textboxColor:uint, forceFocus:Boolean)
        {
            trace("MenuBarDisplay()");
            // Instantiate
            _background = new Quad(1,1,backgroundColor);

            var fontSizeFix:Number = 1.0;

            _blockButton = new MenuButton();
            _blockButton.label = "";
            _blockButton.validate();
            _blockButton.addEventListener(Event.TRIGGERED, onBlockTriggered);

            _reportButton = new MenuButton();
            _reportButton.label = "";
            _reportButton.validate();
            _reportButton.addEventListener(Event.TRIGGERED, onReportTriggered);

            _disableChatButton = new MenuButton();
            _disableChatButton.label = "";
            _disableChatButton.validate();
            _disableChatButton.addEventListener(Event.TRIGGERED, onDisableChatTriggered);

            // Add Children
            addChild(_background);
            addChild(_blockButton);
            addChild(_reportButton);
            addChild(_disableChatButton);

            //new InputViewportScroller(new <FoveaTextInput>[
            //  _replyTI
            //]).setup();
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(e:Event):void {

        }

        private function onMuteTriggered(event:Event):void
        {

        }

        private function onBlockTriggered(event:Event):void
        {

        }

        private function onReportTriggered(event:Event):void
        {

        }

        private function onDisableChatTriggered(event:Event):void
        {

        }

        /**
         * Defines the positioning and size of the Menu Bar
         * @param consoleWidth:Number - The width of the chat console used for children sizig and positioning
         */
        public function layout(consoleWidth:Number):void
        {
            var cursor:Number = 50;
            // Set the background size
            _background.width = consoleWidth;
            _background.height = ChatConsole.theme.settingsHeight;

            _blockButton.x = cursor;
            _blockButton.y = ChatConsole.theme.borderWidth;
            cursor += (consoleWidth - 100) / 3;

            _reportButton.x = cursor;
            _reportButton.y = ChatConsole.theme.borderWidth;
            cursor += (consoleWidth - 100) / 3;

            _disableChatButton.x = cursor;
            _disableChatButton.y = ChatConsole.theme.borderWidth;
        }

        public function getBlockButton():Button {
            return _blockButton
        }

        public function getReportButton():Button {
            return _reportButton
        }

        public function getDisableChatButton():Button {
            return _disableChatButton;
        }

        // public function hide():void {
        //     super.hide();
        // }


        /**
         * Defines a color as a slightly darker color than the base color
         * @param baseColor:uint - The Background Color
         */
        private function getDarkerColor(baseColor:uint):uint
        {
            var r:uint = Color.getRed(baseColor);
            var g:uint = Color.getGreen(baseColor);
            var b:uint = Color.getBlue(baseColor);

            return Color.rgb(
                Math.max(r - 25, 0),
                Math.max(g - 25, 0),
                Math.max(b - 25, 0));
        }


        /**
         * Disposes of this object
         */
        override public function dispose():void
        {
            _blockButton.dispose();
            _reportButton.dispose();
            _disableChatButton.dispose();
        }
    }
}
