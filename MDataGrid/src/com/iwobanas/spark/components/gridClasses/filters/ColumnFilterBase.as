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
package com.iwobanas.spark.components.gridClasses.filters
{
	
	import com.iwobanas.spark.components.MDataGrid;
	import com.iwobanas.spark.components.gridClasses.MDataGridColumn;
	import com.iwobanas.spark.components.gridClasses.MDataGridEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.collections.IList;

	import mx.core.mx_internal;
	
	/**
	 * Dispatched when the state of the filter changes.
	 * Such change may cause different MDataGrid items to be excluded from data provider.
	 * 
	 * @eventType com.iwobanas.spark.components.gridClasses.MDataGridEvent.FILTER_VALUE_CHANGE
	 */
	[Event(name="filterValueChange", type="com.iwobanas.spark.components.gridClasses.MDataGridEvent")]
	
	
	/**
	 * The ColumnFilterBase class defines base class for MDataGrid column filters.
	 * 
	 * Column filters serves as model and controller in the MDataGrid filtering mechanism
	 * while filter editors represents view.
	 * 
	 * Column filters are responsible for:
	 * <ul>
	 * <li>Storing the state of a filter applied to a given column</li>
	 * <li>Exposing <code>filterFunction</code> function and <code>isActive</code> 
	 * variable used by MDataGrid to filter data</li>
	 * <li>Providing information about MDataGrid data to filter editors</li>
	 * </ul>
	 */ 
	public class ColumnFilterBase extends EventDispatcher
	{
        /**
         * Array of filter functions of other active filters applied to this DataGrid.
         * This array is used by <code>matchOtherFilters()</code> to allow dynamic filter change
         * based on changes in other filters.
         */
        private var otherFiltersFilterFunctions:Array;

		/**
		 * Constructor.
		 */
		public function ColumnFilterBase()
		{
		}
		
		[Bindable("filterValueChange")]
		/**
		 * Flag indicating wether this filter is active 
		 * i.e may eliminate some items from MDataGrid data provider.
		 * 
		 * This getter should be overridden by concrete column filters.
		 */
		public /* abstract */ function get isActive():Boolean
		{
			return false;
		}
		
		/**
		 * Reset filter so that it will not filter out any items.
		 * After call to this function <code>isActive</code> should return <code>false</code>.
		 * 
		 * <p>This is abstract function which should be overridden by any subclass.</p>
		 */
		public /* abstract */ function resetFilter():void
		{
		} 
		
		/**
		 * Test if given MDataGrid item should remain in MDataGrid data provider.
		 * 
		 * This function should be overridden by concrete column filters.
		 * 
		 * <p>If filter is active this function is called by MDataGrid for every item
		 * and if <code>false</code> is returned item is eliminated from data provider.
		 * 
		 * If <code>true</code> is returned item remains in data provider 
		 * unless other filter eliminate it.</p>
		 * 
		 * <p>
		 * This function might be called many times during one screen refresh 
		 * so it should not be computationally expensive.
		 * <p>
		 */
		public /* abstract */ function filterFunction(obj:Object):Boolean
		{
			return true;
		}
		
		/**
		 * MDataGrid column related to this filter.
		 */
		public function get column():MDataGridColumn
		{
			return _column;
		}
		/**
		 * @private
		 */
		public function set column(value:MDataGridColumn):void
		{
			if (_column)
			{
				dataGrid.removeEventListener(MDataGridEvent.UNFILTERED_COLLECTION_CHANGE, unfilteredCollectionChangeHandler, false);
				dataGrid.removeEventListener(MDataGridEvent.ACTIVE_FILTERS_CHANGE, activeFiltersChangeHandler, false);
			}
			_column = value;
			if (_column)
			{
				dataGrid.addEventListener(MDataGridEvent.UNFILTERED_COLLECTION_CHANGE, unfilteredCollectionChangeHandler, false, 0, true);
				dataGrid.addEventListener(MDataGridEvent.ACTIVE_FILTERS_CHANGE, activeFiltersChangeHandler, false, 0, true);
			}
		}
		protected var _column:MDataGridColumn;
		
		/**
		 * MDataGrid related to this filter.
		 */
		protected function get dataGrid():MDataGrid
		{
			return column.grid.dataGrid as MDataGrid;
		}
		
		/**
		 * Inform MDataGrid about the change to this filter.
		 */
		protected function commitFilterChange():void
		{
			if (dataGrid)
			{
				dataGrid.invalidateColumnFilters();
			}
			dispatchEvent(new MDataGridEvent(MDataGridEvent.FILTER_VALUE_CHANGE));
		}

        /**
         * @private
         */
        protected function updateOtherFiltersFilterFunctions():void
        {
            var columns:IList = dataGrid.columns;

            otherFiltersFilterFunctions = [];
            for (var i:int = 0; i < columns.length; i++)
            {
                var column:MDataGridColumn = columns.getItemAt(i) as MDataGridColumn;
                if (column)
                {
                    if (column.filter && column.filter != this && column.filter.isActive)
                    {
                        otherFiltersFilterFunctions.push(column.filter.filterFunction);
                    }
                }
            }
        }

        /**
         * Check if the given item will match other filters.
         * @param item
         * @return true if item matches all other filters, false it it will be filtered out.
         */
        protected function otherFiltersMatch(item:Object):Boolean
        {
            for each (var otherFilterFunction:Function in otherFiltersFilterFunctions)
            {
                if (!otherFilterFunction(item))
                    return false;

            }
            return true;
        }
		
		protected function unfilteredCollectionChangeHandler(event:Event):void
		{
		}

        protected function activeFiltersChangeHandler(event:MDataGridEvent):void
        {
            updateOtherFiltersFilterFunctions();
        }
	}
}