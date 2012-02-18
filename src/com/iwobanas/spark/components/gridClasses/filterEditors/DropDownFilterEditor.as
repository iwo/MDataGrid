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
Portions created by the Initial Developer are Copyright (C) 2009
the Initial Developer. All Rights Reserved.

Contributor(s):
*/
package com.iwobanas.spark.components.gridClasses.filterEditors
{
	import com.iwobanas.spark.components.gridClasses.MDataGridColumn;
	import com.iwobanas.effects.SlideDown;
	import com.iwobanas.effects.SlideUp;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;

	/**
	 * The length of the transition when the drop-down closes, in milliseconds.
	 * @default 250
	 */
	[Style(name="closeDuration", type="Number", format="Time", inherit="no")]
	
	/**
	 * The length of the transition when the drop-down opens, in milliseconds.
	 * @default 250
	 */
	[Style(name="openDuration", type="Number", format="Time", inherit="no")]

	/**
	 * The DropDownFilterEditor defines the Decorator class displaying other filter editors as drop-down.
	 * 
	 * <p>Usually you do not extend this class, but create new filter 
	 * and pass it as constructor argument to DropDownFilterEditor</p>
	 * 
	 * @see com.iwobanas.spark.components.gridClasses.filterEditors.IColumnFilterEditor
	 */
	public class DropDownFilterEditor extends FilterEditorBase
	{
		/**
		 * Constructor.
		 * @param editor instance of column filter editor which should be displayed as drop-down.
		 */
		public function DropDownFilterEditor(editor:IColumnFilterEditor)
		{
			super();
			
			addChild(editor as DisplayObject);
			_editor = editor;
			
			addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseDownOutsideHandler);
			addEventListener(Event.DEACTIVATE, deactivateHandler);
			
		}
		
		
		/**
		 * Editor instance displayed inside drop-down.
		 */
		public function get editor():IColumnFilterEditor
		{
			return _editor;
		}
		/**
		 * @private
		 * Storage variable for editor.
		 */
		protected var _editor:IColumnFilterEditor;
		
		
		/**
		 * Start editing filter for the given column.
		 * Call <code>startEdit()</code> on <code>editor</code> and open drop-down.
		 */
		override public function startEdit(column:MDataGridColumn):void
		{
			editor.startEdit(column);
			super.startEdit(column); // this must be called after editor startEdit to correctly set columns editor instance
			PopUpManager.addPopUp(this, Application.application as DisplayObject);
		}
		
		/**
		 * End editing filter for the given column.
		 * Close drop-down and pcall <code>endEdit()</code> on <code>editor</code>
		 */
		override public function endEdit():void
		{
			PopUpManager.removePopUp(this);
			super.endEdit();
			editor.endEdit();
		}
		/**
		 * @private
		 * Override stylesInitialized() function to initialize effects.
		 */
		override public function stylesInitialized():void
		{
			super.stylesInitialized();
			initializeEffects();
		}

		/**
		 * Initialize effects applied to the dropdown when it opens/closes.
		 */
		protected function initializeEffects():void
		{
			var closeDuration:Number = getStyle("closeDuration");
			var openDuration:Number = getStyle("openDuration");
			
			var slideDown:SlideDown = new SlideDown();
			slideDown.duration = openDuration;
			setStyle("creationCompleteEffect", slideDown);
			
			var slideUp:SlideUp = new SlideUp();
			slideUp.duration = closeDuration;
			setStyle("removedEffect", slideUp);
		}
		
		/**
		 * @private
		 * Mouse down outside event handler.
		 * Close dropdown on mouse down outside.
		 */
		protected function mouseDownOutsideHandler(event:FlexMouseEvent):void
		{
			endEdit();
		}
		
		/**
		 * @private
		 * Deactivate event handler.
		 * Close dropdown when window looses focus.
		 */
		protected function deactivateHandler(event:Event):void
		{
			endEdit();
		}
	}
}