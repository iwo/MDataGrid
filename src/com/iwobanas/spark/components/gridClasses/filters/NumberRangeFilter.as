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
	import com.iwobanas.spark.components.gridClasses.MDataGridColumn;
	
	import flash.events.Event;

	/**
	 * The NumberRangeFilter class defines MDataGrid column filter 
	 * which filters numerical values based on specified minimum 
	 * and maximum values.
	 * 
	 * This filter also provides information about range of the values
	 * found in MDataGrid data provider.
	 */
	public class NumberRangeFilter extends ColumnFilterBase
	{
		/**
		 * Constructor.
		 */
		public function NumberRangeFilter()
		{
		}
		
		override public function set column(value:MDataGridColumn):void
		{
			super.column = value;
			updateOriginalDataRange();
		}
		
		/**
		 * Minimum value found in MDataGrid column related to this filter.
		 */
		[Bindable]
		public var dataMinimum:Number;
		
		/**
		 * Maximum value found in MDataGrid column related to this filter
		 */
		[Bindable]
		public var dataMaximum:Number;
		
		/**
		 * Minimum value allowed in MDataGrid column related to this filter.
		 * Items with value less than <code>minimum</code> will be eliminated.
		 */
		[Bindable]
		public function get minimum():Number
		{
			return _minimum;
		}
		/**
		 * @private
		 */
		public function set minimum(value:Number):void
		{
			_minimum = value;
			minActive = (minimum != dataMinimum);
			commitFilterChange();
		}
		/**
		 * @private
		 * Storage variable for minimum property.
		 */
		protected var _minimum:Number;
		
		/**
		 * Maximum value allowed in MDataGrid column related to this filter.
		 * Items with value greater than <code>minimum</code> will be eliminated.
		 */
		[Bindable]
		public function get maximum():Number
		{
			return _maximum;
		}
		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			_maximum = value;
			maxActive = (maximum != dataMaximum);
			commitFilterChange();
		}
		/**
		 * @private
		 * Storage variable for maximum.
		 */
		protected var _maximum:Number;
		
		/**
		 * Update <code>dataMinimum</code> and <code>dataMaximum</code> values.
		 */
		protected function updateOriginalDataRange():void
		{
			var min:Number = Number.MAX_VALUE;
			var max:Number = Number.MIN_VALUE;
			for each (var item:Object in dataGrid.originalCollection)
			{
				var value:Number = itemToNumber(item);
				if (!isNaN(value))
				{
					min = Math.min(value, min);
					max = Math.max(value, max);
				}
			}
			dataMinimum = min;
			dataMaximum = max;
			if (!minActive)
			{
				minimum = min;
			}
			if (!maxActive)
			{
				maximum = max;
			}
		}
		
		/**
		 * @private
		 * Collection change event handler attached to original collection of MDataGrid.
		 */ 
		override protected function originalCollectionChangeHandler(event:Event):void
		{
			updateOriginalDataRange();
		}
		
		/**
		 * Return numeric value for the given item.
		 * @param item MDataGrid item.
		 * @return numeric value for the given item.
		 */
		protected function itemToNumber(item:Object):Number
		{
			var value:Number
			try
			{
				if (column.dataField)
				{
					value = Number(item[column.dataField]);
				}
				else
				{
					value = Number(column.itemToLabel(item));
				}
			}
			catch(e:Error)
            {
            }
            return value;
		}
		
		/**
		 * Indicate whether some items may be filtered by minimum (i.e. minimum > dataMinimum).
		 */
		protected var minActive:Boolean = false;
		
		/**
		 * Indicate whether some items may be filtered by maximum (i.e. maximum < dataMaximum).
		 */
		protected var maxActive:Boolean = false;
		
		/**
		 * Flag indicating wether this filter is active 
		 * i.e may eliminate some items from MDataGrid data provider.
		 */
		override public function get isActive():Boolean
		{
			return minActive || maxActive;
		}
		
		/**
		 * Reset filter so that it will not filter out any items.
		 * After call to this function filter becomes inactive <code>isActive = false</code>.
		 */
		override public function resetFilter():void
		{
			minimum = dataMinimum;
			maximum = dataMaximum;
		}
		
		/**
		 * Test if given MDataGrid item should remain in MDataGrid data provider.
		 */
		override public function filterFunction(obj:Object):Boolean
		{
			var value:Number = itemToNumber(obj);
			
			if (!isNaN(value))
			{
				if (!isNaN(minimum) && value < minimum)
				{
					return false;
				}
				if (!isNaN(maximum) && value > maximum)
				{
					return false;
				}
			}
			return true;
		}
	}
}