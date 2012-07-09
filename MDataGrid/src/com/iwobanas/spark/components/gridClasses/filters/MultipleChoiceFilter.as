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
	import com.iwobanas.spark.components.gridClasses.MDataGridEvent;

	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.utils.ObjectUtil;

/**
	 * The MultipleChoiceFilter class defines MDataGrid column filter 
	 * exposing the list of different values appearing in MDataGrid
	 * column and allowing user to select which values should be displayed.
	 * 
	 * This filter should be applied to columns containing repeating values.
	 */
	public class MultipleChoiceFilter extends ColumnFilterBase
	{
		/**
		 * Constructor.
		 */
		public function MultipleChoiceFilter()
		{			
		}
		
		override public function set column(value:MDataGridColumn):void
		{
			super.column = value;
			updateLabels();
		}
		
		/**
		 * List of all different labels appearing in column related to this filter.
		 */
		[Bindable]
		public var labels:ArrayCollection;
		
		/**
		 * List of selected labels.
		 * Only items with labels from this list will be included in MDataGrid data provider.
		 */
		[Bindable]
		public var selectedLabels:ArrayCollection = new ArrayCollection();

        public var allSelected:Boolean;
		
		/**
		 * Select given label by adding it to <code>selectedLabels</code> list.
		 */
		public function selectLabel(label:String):void
		{
			if (!selectedLabels.contains(label))
			{
				selectedLabels.addItem(label);
			}
			commitFilterChange();
		}
		
		/**
		 * Deselect given label by adding it to <code>selectedLabels</code> list.
		 */
		public function deselectLabel(label:String):void
		{
			if (selectedLabels.contains(label))
			{
				selectedLabels.removeItemAt(selectedLabels.getItemIndex(label));
			}
			commitFilterChange();
		}
		
		/**
		 * Select all labels.
		 */
		public function selectAll():void
		{
			for each (var label:String in labels)
			{
				if (!selectedLabels.contains(label))
				{
					selectedLabels.addItem(label);
				}
			}
			commitFilterChange();
		}
		
		/**
		 * Deselect all labels.
		 */
		public function deselectAll():void
		{
			selectedLabels.removeAll();
			commitFilterChange();
		}
		
		/**
		 * Update <code>isActive</code> and then inform MDataGrid about the change to this filter.
		 */
		override protected function commitFilterChange():void
		{
			var active:Boolean = false;
			if (selectedLabels.length > 0)
			{
				for each (var label:String in labels)
				{
					if (!selectedLabels.contains(label))
					{
						active = true;
						break;
					}
				}
                allSelected = !active;
			}
            else
            {
                allSelected = false;
            }
			_isActive = active;
			super.commitFilterChange();
		}
		
		/**
		 * Update labels list by iterating through MDataGrid original collection.
		 */
		protected function updateLabels():void
		{
            var newLabels:Array = getLabels();

            if (labels && ObjectUtil.compare(newLabels, labels.source) == 0)
                return;

			labels = new ArrayCollection(newLabels);
			if (allSelected)
			{
				selectedLabels = new ArrayCollection(newLabels.concat());
			}
		}

        protected function getLabels():Array
        {
            var labelsMap:Object = {};
            var labels:Array = [];
			var label:String;

            for each (var item:Object in dataGrid.unfilteredCollection)
            {
                if (!otherFiltersMatch(item))
                {
                    continue;
                }

				label = column.itemToLabel(item);
                if (label && !labelsMap[label])
                {
                    labelsMap[label] = true;
                    labels.push(label);
                }
            }

			for each (label in selectedLabels)
			{
				if (!labelsMap[label])
				{
					labelsMap[label] = true;
					labels.push(label);
				}
			}

            labels.sort(Array.CASEINSENSITIVE);
            return labels;
        }
		
		/**
		 * MDataGrid original collection change event handler.
		 */
		override protected function unfilteredCollectionChangeHandler(event:Event):void
		{
			updateLabels();
		}

        override protected function activeFiltersChangeHandler(event:MDataGridEvent):void
        {
            super.activeFiltersChangeHandler(event);
            updateLabels();
        }
		
		[Bindable("filterValueChange")]
		/**
		 * Flag indicating wether this filter is active 
		 * i.e may eliminate some items from MDataGrid data provider.
		 */
		override public function get isActive():Boolean
		{
			return _isActive;
		}
		
		/**
		 * Reset filter so that it will not filter out any items.
		 * After call to this function filter becomes inactive <code>isActive = false</code>.
		 */
		override public function resetFilter():void
		{
			deselectAll();
		}
		
		/**
		 * @private
		 * Storage variable for <code>isActive</code> flag.
		 */
		protected var _isActive:Boolean = false;
		
		/**
		 * Test if given MDataGrid item should remain in MDataGrid data provider.
		 */
		override public function filterFunction(obj:Object):Boolean
		{
			return selectedLabels.contains(column.itemToLabel(obj));
		}
	}
}