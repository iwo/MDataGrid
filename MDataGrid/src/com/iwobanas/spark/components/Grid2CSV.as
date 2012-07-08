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
	import mx.collections.IList;
	
	import spark.components.Grid;
	import spark.components.gridClasses.GridColumn;
	
	/**
	 * The DataGrid2CSV defines utility class to export data displayed in the Grid to CSV format.
	 * 
	 * <p>Note that Grid2CSV does not handle saving CSV file to filesystem or transmitting it over network,
	 * all what Grid2CSV does is returning String containing data in SCV format which then may 
	 * be saved or transmitted by application code.</p>
	 */
	public class Grid2CSV
	{
		
		[Bindable]
		/**
		 * Target Spark Grid from which data should be exported.
		 * If used with Spark DataGrid the DataGrid.grid skin part should be passed.
		 */
		public var target:Grid;
		
		
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
		 * Get the data from Grid formatted as CSV.
		 * All parameters including <code>target</code> have to be set before call to this function.
		 * 
		 * @return Grid formatted as CSV or empty String if <code>target</code> is not set.
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
			
			for (var i:int = 0; i < target.columns.length; i++)
			{
				var column:GridColumn = GridColumn(target.columns.getItemAt(i));
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
		 * This function iterates over Grid data provider and calls <code>getDataRow()</code>.
		 * 
		 * @return all data rows in CSV format
		 */
		protected function getDataRows():String
		{
			var result:String = "";
			const dataProvider:IList = target.dataProvider;
			const dataProviderLength:int = dataProvider.length;
			
			for (var i:int = 0; i < dataProviderLength; i++)
			{
				result += getDataRow(dataProvider.getItemAt(i));
			}
			return result;
		}
		
		/**
		 * Get data row in CSV format for a given Grid item.
		 * 
		 * @return data row in CSV format
		 */
		protected function getDataRow(item:Object):String
		{
			var result:String = "";
			const columns:IList = target.columns;
			const columnsLength:int = columns.length;
			var isFirstVisibleCol:Boolean = true;
			
			for (var i:int = 0; i < columnsLength; i++)
			{
				var column:GridColumn = GridColumn(columns.getItemAt(i));
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
		 * Get the String value for a given Grid item and column.
		 * Depending on <code>useRawData</code> flag this may be label
		 * created using label function or raw data converted to String.
		 * 
		 * @param item Grid item for which value should be returned
		 * @param coulmn GridColumn for which value should be returned
		 * 
		 * @return value for a given Grid item and column
		 */
		protected function getFieldValue(item:Object, column:GridColumn):String
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