package com.iwobanas.controls
{
	import mx.collections.CursorBookmark;
	import mx.collections.IViewCursor;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	
	/**
	 * The DataGrid2CSV defines utility class to export data displayed in DataGrid to CSV format.
	 * 
	 * <p>Note that DataGrid2CSV does not handle saving CSV file to filesystem or transmitting it over network,
	 * all what DataGrid2CSV does is returning String containing data in SCV format which then may 
	 * be saved or transmitted by application code.</p>
	 */
	public class DataGrid2CSV
	{
		
		[Bindable]
		/**
		 * Target DataGrid from which data should be exported.
		 * This may also be subclass of DataGrid for example MDataGrid.
		 */
		public var target:DataGrid;
		
		
		[Bindable]
		/**
		 * String used to separate columns in exported data.
		 * According to RFC 4180 this should be comma.
		 * Column separator is not added after last column in row.
		 */
		public var columnSeparator:String = ",";
		
		
		[Bindable]
		/**
		 * String used to separate rows in exported data.
		 * According to RFC 4180 this should be CRLF.
		 */
		public var rowSeparator:String = "\r\n";
		
		
		[Bindable]
		/**
		 * Flag indicating if raw data should be used when possible.
		 * 
		 * If <code>true</code> label functions will not be used for columns 
		 * with <code>dataField</code> defined i.e. standard <code>toString()</code> 
		 * function will be used.
		 * 
		 * If <code>false</code> label functions will be used for all columns
		 * with label function defined.
		 */
		public var useRawData:Boolean = false;
		
		
		[Bindable]
		/**
		 * Flag indicating if header row should be added at the top of CSV document.
		 */
		public var includeHeader:Boolean = true;
		
		
		/**
		 * Get the data from DataGrid formatted as CSV.
		 * All parameters including <code>target</code> have to be set before call to this function.
		 * 
		 * @return DataGrid formatted as CSV or empty String if <code>target</code> is not set.
		 */
		public function getCSV():String
		{
			if (!target || !target.columns || target.columns.length == 0)
			{
				return "";
			}
			var result:String = "";
			if (includeHeader)
			{
				result += getHeadrRow();
			}
			result += getDataRows();
			return result;
		}
		
		
		/**
		 * Get header row in CSV format.
		 * 
		 * @return header row in CSV format
		 */
		protected function getHeadrRow():String
		{
			var result:String = "";
			var isFirstVisibleCol:Boolean = true;
			
			for each(var column:DataGridColumn in target.columns)
			{
				if (column.visible)
				{
					if (isFirstVisibleCol)
					{
						isFirstVisibleCol = false;
					}
					else
					{
						result += columnSeparator;
					}
					result += escapeValue(column.headerText);
				}
			}
			result += rowSeparator;
			
			return result;
		}
		
		
		/**
		 * Get all data rows in CSV format.
		 * This function iterates over DataGrid data provider and calls <code>getDataRow()</code>.
		 * 
		 * @return all data rows in CSV format
		 */
		protected function getDataRows():String
		{
			var result:String = "";
			var cursor:IViewCursor = target.dataProvider.createCursor();
			cursor.seek(CursorBookmark.FIRST);
			
			while (!cursor.afterLast)
			{
				result += getDataRow(cursor.current);
				cursor.moveNext();
			}
			return result;
		}
		
		/**
		 * Get data row in CSV format for a given DataGrid item.
		 * 
		 * @return data row in CSV format
		 */
		protected function getDataRow(item:Object):String
		{
			var result:String = "";
			var isFirstVisibleCol:Boolean = true;
			
			for each(var column:DataGridColumn in target.columns)
			{
				if (column.visible)
				{
					if (isFirstVisibleCol)
					{
						isFirstVisibleCol = false;
					}
					else
					{
						result += columnSeparator;
					}
					result += getFieldValue(item, column);
				}
			}
			result += rowSeparator;
			
			return result;
		}
		
		/**
		 * Get the String value for a given DataGrid item and column.
		 * Depending on <code>useRawData</code> flag this may be label
		 * created using label function or raw data converted to String.
		 * 
		 * @param item DataGrid item for which value should be returned
		 * @param coulmn DataGrid column for which value should be returned
		 * 
		 * @return value for a given DataGrid item and column
		 */
		protected function getFieldValue(item:Object, column:DataGridColumn):String
		{
			var result:String = "";
			if (useRawData && column.dataField)
			{
				try
				{
					result = escapeValue(item[column.dataField]);
				}
				catch(e:Error){} //ignore any errors - just like in DataGrid
			}
			else
			{
				result = escapeValue(column.itemToLabel(item));
			}
			return result;
		}
		
		/**
		 * Escape passed value so that it can be used as CSV field.
		 * By default all fields are surrounded with double quotes 
		 * and double quotes inside field are escaped by adding 
		 * double quotes (see RFC 4180).
		 * 
		 * @param value value which should be escaped
		 * @return escaped value
		 */
		protected function escapeValue(value:String):String
		{
			return '"' + value.replace('"','""') + '"';
		}

	}
}