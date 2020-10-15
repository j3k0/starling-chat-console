package fovea.chat.menu_bar
{
    import fovea.chat.Controller;
    import fovea.chat.objects.MenuButton;
    import feathers.controls.Button;

    /**
     * Chat message reply window controller</br>
     * Handles:
     * <ul>
     *      <li>Displaying the keyboard</li>
     *      <li>Passing data to the view </li>
     * </ul>
     */
    public class MenuBar extends Controller
    {
        /** MenuBar Display */
        public function get view():MenuBarDisplay {return _view as MenuBarDisplay;}

        /**
         * Instantiates a MenuBar controller
         * @param backgroundColor:uint - Background color of the MenuBar
         * @param textboxColor:uint - Background color of the MenuBar TextArea
         */
        public function MenuBar(backgroundColor:uint, textboxColor:uint, forceFocus:Boolean)
        {
            _view = new MenuBarDisplay(backgroundColor, textboxColor, forceFocus);
        }

        /**
         * Defines the positioning and size of the reply window
         * @param consoleWidth:Number - The width of the chat console used for children sizig and positioning
         */
        public function layout(consoleWidth:Number):void
        {
            view.layout(consoleWidth);
        }

        public function getBlockButton():Button
        {
            return view.getBlockButton();
        }

        public function getReportButton():Button
        {
            return view.getReportButton();
        }

        public function hide():void
        {
            return view.hide();
        }

        /**
         * Disposes of this object
         */
        public function dispose():void
        {
            _view.dispose();
        }
    }
}
