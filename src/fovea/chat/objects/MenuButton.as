package fovea.chat.objects
{
    import feathers.controls.Button;

    import fovea.chat.ChatUtil;

    import starling.display.Quad;

    /**
     * Button class wrapped used to update the menu button's touch square.
     */
    public class MenuButton extends Button
    {
        /** padding added to all sides, to enable easier touch capability */
        private var _touchPadding:Number;
        /** A background object to make the button easier to touch */
        private var _touchQuad:Quad;

        /** padding to enable easier touch capability */
        public function set touchPadding(value:Number):void
        {
            _touchPadding = value;
            layout();
        }

        /**
         * Instantiate MenuButton
         * @param touchPadding:Number -  padding added to all sides, to enable easier touch capability
         */
        public function MenuButton(touchPadding:Number = 0)
        {
            _touchQuad = new Quad(1,1, 0xFF0000);
            _touchQuad.alpha = 0;
            _touchPadding = touchPadding;

            addChild(_touchQuad);
        }

        /**
         * Resizes the buttons touch quad
         */
        public function layout():void
        {
            _touchQuad.x = -_touchPadding;
            _touchQuad.y = -_touchPadding;
            _touchQuad.width = width +  (_touchPadding * 2);
            _touchQuad.height = height + (_touchPadding * 2);
        }
    }
}
