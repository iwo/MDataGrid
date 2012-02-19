package com.iwobanas.spark.components
{
	import spark.components.ToggleButton;

	/**
	 * The ProgrammaticToggleButton component modifies the bahavior of ToggleButton
	 * so that the selection (toggle) isn't changed on user interaction.
	 * 
	 * It can be changed programmaticaly by setting <code>selected</code> property.
	 */
	public class ProgrammaticToggleButton extends ToggleButton
	{
		public function ProgrammaticToggleButton()
		{
			super();
		}
		
		override protected function buttonReleased():void
		{
			//don't toggle based on click
		}
	}
}