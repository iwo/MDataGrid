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
	import com.iwobanas.spark.components.gridClasses.MDataGridColumn;
	import com.iwobanas.spark.components.gridClasses.MDataGridEvent;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ISort;
	import mx.collections.ListCollectionView;
	
	import spark.components.DataGrid;
	import spark.components.gridClasses.GridColumn;
	
	/**
	 * Dispatched when the <code>originalCollection</code> property changes.
	 * 
	 * @eventType com.iwobanas.spark.components.gridClasses.MDataGridEvent.UNFILTERED_COLLECTION_CHANGE
	 */
	[Event(name="unfilteredCollectionChange",type="com.iwobanas.spark.components.gridClasses.MDataGridEvent")]

    /**
     * Dispatched when the change in the selected filters takes effect i.e. during <code>commitProperties()</code>.
     *
     * @eventType com.iwobanas.spark.components.gridClasses.MDataGridEvent.ACTIVE_FILTERS_CHANGE
     */
    [Event(name="activeFiltersChange",type="com.iwobanas.spark.components.gridClasses.MDataGridEvent")]

	/**
	 * The MDataGrid class extends Spark DataGrid by adding filtering and preserving sort on data provider change.
	 * 
	 * @see com.iwobanas.spark.components.gridClasses.MDataGridColumn
	 */
	public class MDataGrid extends DataGrid
	{
		/**
		 * Constructor.
		 */
		public function MDataGrid()
		{
			super();
		}
		
		/**
		 * @private
		 * dataProvider cast to ICollectionView
		 */
		private var collection:ICollectionView;
		
		/**
		 * @private 
		 */
		private var _unfilteredCollection:ICollectionView;
		
		[Bindable("unfilteredCollectionChange")]
		/**
		 * Shallow copy of dataProvider without filters applied.
		 */
		public function get unfilteredCollection():ICollectionView
		{
			return _unfilteredCollection;
		}

		/**
		 * Flag indicating if dynamic filtering i.e. changing state of one filter based on the selection to the other is enabled.
		 * Setting this flag to <code>false</code> may improve performance.
		 * @default true
		 */
		public var dynamicFilteringEnabled:Boolean = true;
		
		/**
		 * @private 
		 * Update unfilteredCollection based on the current value of collection.
		 * This function has to be called before any filters are applied to the input collection.
		 */
		private function updateUnfilteredCollection():void
		{
			if (!collection)
			{
				_unfilteredCollection = null;
			}
			else if (collection is ListCollectionView)
			{
				_unfilteredCollection = new ListCollectionView(ListCollectionView(collection).list);
			}
			else
			{
				_unfilteredCollection = new ListCollectionView(IList(collection));
			}
			dispatchEvent(new MDataGridEvent(MDataGridEvent.UNFILTERED_COLLECTION_CHANGE));
		}
		
		/**
		 * @private 
		 */
		override public function set dataProvider(value:IList):void
		{
			if (value === dataProvider)
				return;
			
			var sort:ISort = collection ? collection.sort : null;
			
			collection = value as ICollectionView;
			updateUnfilteredCollection();
			
			if (collection && sort)
			{
				collection.sort = sort;
				collection.refresh();
			}
			
			super.dataProvider = value;
			invalidateColumnFilters();
		}
		
		/**
		 * @private
		 * Flag indicating that column filters have changed and data provider needs to be refreshed.
		 */
		protected var columnFiltersChanged:Boolean = false;
		
		[Bindable]
		/**
		 * Flag indicating if column any filter is active.
		 */
		public var filtersActive:Boolean;
		
		/**
		 * Reset all filters so that all filters become inactive.
		 * After call to this function unfiltered data are displayed.
		 */
		public function resetAllFilters():void
		{
			for (var i:int = 0; i < columns.length; i++)
			{
				var column:MDataGridColumn = columns.getItemAt(i) as MDataGridColumn;
				if (column && column.filter)
				{
					column.filter.resetFilter();
				}
			}
			invalidateColumnFilters();
		}
		
		/**
		 * Mark datagrid so that data provider will be refreshed
		 * (new filters values will take effect) on next call commitProperties().
		 * 
		 * This function may eventually be called by <code>"filteChange"</code> 
		 * and <code>"filterValueChange"</code> event handlers but for now 
		 * it is directly called by ColumnFilterBase.
		 */
		public function invalidateColumnFilters():void
		{
			columnFiltersChanged = true;
			invalidateProperties();
		}
		
		/**
		 * @private
		 * Array of filter functions of active column filters.
		 */
		protected var columnFilterFunctions:Array;
		
		/**
		 * @private
		 * Examine column filters and assign filter functions 
		 * of active filters to <code>columnFilterFunctions</code>.
		 */
		protected function updateColumnFilterFunctions():void
		{
			var cff:Array = [];
			for (var i:int = 0; i < columns.length; i++)
			{
				var column:MDataGridColumn = columns.getItemAt(i) as MDataGridColumn;
				if (column)
				{
					if (column.filter && column.filter.isActive)
					{
						cff.push(column.filter.filterFunction);
					}
				}
			}
			columnFilterFunctions = cff;
		}
		
		/**
		 * @private
		 * Filter function to be passed to data provider.
		 * This function is a logical AND of all functions in <code>columnFilterFunctions</code>
		 * i.e. if any of the functions in <code>columnFilterFunctions</code> return false
		 * this function will return false and item will be filtered out.
		 */
		protected function collectionFilterFunction(obj:Object):Boolean
		{
			//TODO: handle original collection filter
			for each (var cff:Function in columnFilterFunctions)
			{
				if (!cff(obj))
				{
					return false;
				}
			} 
			return true;
		}
		
		/**
		 * @private
		 */ 
		override protected function commitProperties():void
		{
			if (columnFiltersChanged)
			{
				columnFiltersChanged = false;
				updateColumnFilterFunctions();
				filtersActive = (columnFilterFunctions.length > 0);
				if (collection)
				{
					collection.filterFunction = collectionFilterFunction;
					collection.refresh();
				}
                dispatchEvent(new MDataGridEvent(MDataGridEvent.ACTIVE_FILTERS_CHANGE));
			}
			super.commitProperties();
		}

	}
}