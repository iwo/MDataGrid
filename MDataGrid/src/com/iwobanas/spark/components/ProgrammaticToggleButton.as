/*
 The contents of this file are subject to the Mozilla Public License
 Version 1.1 (the "License"); you may not use this file except in
 compliance with the License. You may obtain a copy of the License at
 http://www.mozilla.org/MPL/

 Software distributed under the License is distributed on an "AS IS"
 basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 License for the specific language governing rights and limitations
 under the License.

 The Original Code is: www.iwobanas.com code samples.

 The Initial Developer of the Original Code is Iwo Banas.
 Portions created by the Initial Developer are Copyright (C) 2012
 the Initial Developer. All Rights Reserved.

 Contributor(s):
 */
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
		/**
		 * Constructor.
		 */
		public function ProgrammaticToggleButton()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function buttonReleased():void
		{
			//don't toggle based on click
		}
	}
}