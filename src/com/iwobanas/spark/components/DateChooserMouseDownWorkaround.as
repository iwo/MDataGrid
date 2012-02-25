package com.iwobanas.spark.components
{
	import flash.events.MouseEvent;
	
	import mx.controls.DateChooser;
	
	/**
	 * @private 
	 * The DateChooserMouseDownWorkaround extends DateChooser and stops propagation of all mouseDown events.
	 * This is a workaround for the problem with DateField inside drop downs (2 levels of dorp downs). 
	 */
	[ExcludeClass]
	public class DateChooserMouseDownWorkaround extends DateChooser
	{
		public function DateChooserMouseDownWorkaround()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
	}
}