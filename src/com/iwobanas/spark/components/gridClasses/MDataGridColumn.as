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
package com.iwobanas.spark.components.gridClasses
{
	import com.iwobanas.spark.components.MDataGrid;
	import com.iwobanas.spark.components.gridClasses.filterEditors.IColumnFilterEditor;
	import com.iwobanas.spark.components.gridClasses.filterEditors.WildcardFilterEditor;
	import com.iwobanas.spark.components.gridClasses.filters.ColumnFilterBase;
	import com.iwobanas.spark.components.gridClasses.MGridHeaderRenderer;
	
	import flash.events.Event;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.mx_internal;
	
	import spark.components.gridClasses.GridColumn;

	/**
	 * Dispatched when the <code>filter</code> property changes.
	 * 
	 * @eventType com.iwobanas.spark.components.gridClasses.MDataGridEvent.FILTER_CHANGE
	 */
	[Event(name="filterChange", type="com.iwobanas.spark.components.gridClasses.MDataGridEvent")]
	
	/**
	 * The name of a CSS style declaration for controlling the appearance of the column filter editor.
	 */
	[Style(name="filterEditorStyleName", type="String", inherit="no")]
	
	
	/**
	 * The MDataGridColumn class describes a column in a MDataGrid control.
	 * 
	 * It extends GridColumn functionality by adding filtering support.
	 * 
	 * FIXME: Update documentation
	 * MDataGridColumn also changes default renderers.
	 * Default item renderer is BoldSearchItemRenderer and 
	 * default header renderer is DropDownFilterHeaderRenderer.
	 * 
	 * @see mx.controls.dataGridClasses.DataGridColumn
	 * @see com.iwobanas.spark.components.gridClasses.BoldSearchItemRenderer
	 * @see com.iwobanas.spark.components.gridClasses.DropDownFilterHeaderRenderer
	 */
	public class MDataGridColumn extends GridColumn
	{
		/**
		 * Constructor.
		 */
		public function MDataGridColumn(columnName:String=null)
		{
			super(columnName);
			
			// set default renderers
			headerRenderer = new ClassFactory(com.iwobanas.spark.components.gridClasses.MGridHeaderRenderer);
			//filterEditor = new ClassFactory(com.iwobanas.spark.components.gridClasses.filterEditors.WildcardFilterEditor);
		}
		
		/**
		 * The class factory for filter editor instances that edits column filter values.
		 * Objects created by this factory should implement IColumnFilterEditor interface.
		 * 
		 * @see com.iwobanas.spark.components.gridClasses.filterEditors.IColumnFilterEditor
		 * 
		 * @default WildcardFilterEditor
		 */
		public var filterEditor:IFactory;
		
		/**
		 * @private
		 * Column filter instance related to this column.
		 * Filters are used by MDataGrid to filter data provider content.
		 * This property should be modified only by filter editor instance.
		 */
		[Bindable("filterChange")]
		public function get filter():ColumnFilterBase
		{
			return _filter;
		}
		/**
		 * @private
		 */
		public function set filter(value:ColumnFilterBase):void
		{
			_filter = value;
			_filter.column = this;
			MDataGrid(mx_internal::owner).invalidateColumnFilters();
			dispatchEvent(new Event("filterChange"));
		}
		/**
		 * @private
		 * Storage for filter variable.
		 */
		protected var _filter:ColumnFilterBase;
		
		/**
		 * @private
		 * Filter editor instance currently editing filter.
		 * Only one filter editor instance should edit filter at a time.
		 */
		public var filterEditorInstance:IColumnFilterEditor;
		
	}
}