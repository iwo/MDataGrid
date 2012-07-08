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
	
	import mx.containers.Box;
	import mx.events.CloseEvent;
	import mx.skins.halo.HaloBorder;
	
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.Skin;

	/**
	 * The FilterEditorBase class provides default implementation 
	 * of IColumnFilterEditor interface and defines base class 
	 * for some column filter editors.
	 * 
	 * TODO: Refactor Filter editor classes so that each editor is a separate SkinnableComponent instead of using SkinnableContainer.
	 */
	public class FilterEditorBase extends SkinnableContainer implements IColumnFilterEditor
	{
		/**
		 * Construcotr.
		 */
		public function FilterEditorBase()
		{
			super();
		}
		
		/**
		 * Column related with this filter editor.
		 */
		[Bindable]
		public var column:MDataGridColumn;
		
		/**
		 * Start editing filter for the given column.
		 * 
		 * <p>Subclases usually override this function to update columns <code>filter</code> property.
		 * When overriding this function it is important to call <code>super.startEdit(column)</code>.</p>
		 */
		public function startEdit(column:MDataGridColumn):void
		{
			this.column = column;
		}
		
		
		/**
		 * Stop editing filter for the given column.
		 */
		public function endEdit():void
		{
		}
		
		/**
		 * Dispatch CloseEvent.CLOSE.
		 * If this filter editor is used as a dropdown calling dispatchCloseEvent() will close the dropdown.
		 */
		protected function dispatchCloseEvent():void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
	}
}