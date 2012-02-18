package com.iwobanas.spark.components
{
	import com.iwobanas.spark.components.gridClasses.MDataGridColumn;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	
	import spark.components.DataGrid;
	import spark.components.gridClasses.GridColumn;
	
	public class MDataGrid extends DataGrid
	{
		public function MDataGrid()
		{
			super();
		}
		
		private var collection:ICollectionView;
		
		private var _unfilteredCollection:ICollectionView;
		
		public function get unfilteredCollection():ICollectionView
		{
			return _unfilteredCollection;
		}
		
		override public function set dataProvider(value:IList):void
		{
			collection = value as ICollectionView;
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
				_unfilteredCollection = new ListCollectionView(value);
			}
			
			super.dataProvider = value;
		}
		
		/**
		 * @private
		 * Flag indicating that column filters have changed and data provider needs to be refreshed.
		 */
		protected var columnFiltersChanged:Boolean = false;
		
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
			//FIXME: change iteration method
			for each (var column:GridColumn in columns.toArray())
			{
				if (column is MDataGridColumn)
				{
					var mc:MDataGridColumn = MDataGridColumn(column);
					if (mc.filter && mc.filter.isActive)
					{
						cff.push(mc.filter.filterFunction);
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
				if (collection)
				{
					collection.filterFunction = collectionFilterFunction;
					collection.refresh();
				}
			}
			super.commitProperties();
		}

	}
}