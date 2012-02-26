package com.iwobanas.spark.components.gridClasses
{
	import com.iwobanas.spark.components.gridClasses.filterEditors.FilterEditorBase;
	import com.iwobanas.spark.components.gridClasses.filterEditors.IColumnFilterEditor;
	import com.iwobanas.spark.components.gridClasses.filters.ColumnFilterBase;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	
	import spark.components.PopUpAnchor;
	import spark.components.ToggleButton;
	import spark.components.gridClasses.GridItemRenderer;
	import spark.components.supportClasses.DropDownController;
	import spark.events.DropDownEvent;
	
	public class MGridHeaderRendererBase extends GridItemRenderer
	{
		public function MGridHeaderRendererBase()
		{
			super();
			dropDownController = new DropDownController();
		}
		
		/**
		 *  @private
		 */
		private var _dropDownController:DropDownController; 
		
		/**
		 *  Instance of the DropDownController class that handles all of the mouse, keyboard 
		 *  and focus user interactions. 
		 */
		protected function get dropDownController():DropDownController
		{
			return _dropDownController;
		}
		
		/**
		 *  @private
		 */
		protected function set dropDownController(value:DropDownController):void
		{
			if (_dropDownController == value)
				return;
			
			_dropDownController = value;
			
			_dropDownController.addEventListener(DropDownEvent.OPEN, dropDownController_openHandler);
			_dropDownController.addEventListener(DropDownEvent.CLOSE, dropDownController_closeHandler);
			
			if (filterButton)
				_dropDownController.openButton = filterButton;
			
			_dropDownController.dropDown = getFilterEditor() as DisplayObject;    
		}
		
		protected var filterEditorInstance:IColumnFilterEditor;
		
		protected var filterEditorFactory:IFactory;
		
		protected function getFilterEditor(create:Boolean = false):IColumnFilterEditor
		{
			if (filterColumn)
			{
				if (create && (!filterEditorInstance || !filterColumn.filterEditor != filterEditorFactory))
				{
					filterEditorFactory = filterColumn.filterEditor;
					filterEditorInstance = filterEditorFactory.newInstance();
				}
				return filterEditorInstance;
			}
			return null;
		}
		
		
		[Bindable]
		public var popUpAnchor:PopUpAnchor;
		
		
		private var _filterButton:ToggleButton;
		
		[Bindable("filterButtonChange")]
		public function get filterButton():ToggleButton
		{
			return _filterButton;
		}
		
		public function set filterButton(value:ToggleButton):void
		{
			if (value == _filterButton)
				return;
			
			if (_filterButton)
			{
				_filterButton.removeEventListener(MouseEvent.MOUSE_DOWN, filterButton_mouseDownHandler);
				_filterButton.removeEventListener(MouseEvent.CLICK, filterButton_clickHandler);
			}
			
			_filterButton = value;
			
			if (_dropDownController)
				_dropDownController.openButton = _filterButton;
			
			if (_filterButton)
			{
				_filterButton.addEventListener(MouseEvent.MOUSE_DOWN, filterButton_mouseDownHandler);
				_filterButton.addEventListener(MouseEvent.CLICK, filterButton_clickHandler);
			}
			
			updateFilterButtonState();
			
			dispatchEvent(new Event("filterButtonChange"));
		}
		
		protected var filterColumn:MDataGridColumn;
		
		/**
		 *  @private
		 */
		override public function prepare(hasBeenRecycled:Boolean):void
		{
			super.prepare(hasBeenRecycled);
			
			if (filterColumn != column)
			{
				if (filterColumn)
					filterColumn.removeEventListener(MDataGridEvent.FILTER_CHANGE, filterColumn_filterChangeHandler);
				
				filterColumn = column as MDataGridColumn;
				
				if (filterColumn)
					filterColumn.addEventListener(MDataGridEvent.FILTER_CHANGE, filterColumn_filterChangeHandler);
			}
		}
		
		protected var filter:ColumnFilterBase;
		
		protected function filterColumn_filterChangeHandler(event:Event):void
		{
			if (filterColumn && filterColumn.filter == filter)
				return;
			
			if (filter)
				filter.removeEventListener(MDataGridEvent.FILTER_VALUE_CHANGE, filter_filterValueChange);
			
			filter = filterColumn ? filterColumn.filter : null;
			
			if (filter)
				filter.addEventListener(MDataGridEvent.FILTER_VALUE_CHANGE, filter_filterValueChange);
		}
		
		protected function filter_filterValueChange(event:Event):void
		{
			updateFilterButtonState();
		}
		
		protected function updateFilterButtonState():void
		{
			if (!filterButton)
				return;
			
			filterButton.selected = filter && filter.isActive;
		}
		
		protected function openFilterEditor():void
		{
			if (!filterColumn)
				return;
			
			popUpAnchor.popUp = getFilterEditor(true);
			dropDownController.dropDown = popUpAnchor.popUp as DisplayObject;
			popUpAnchor.displayPopUp = true;
			filterEditorInstance.startEdit(filterColumn);
		}
		
		protected function closeFilterEditor():void
		{
			if (!filterColumn)
				return;
			filterEditorInstance.endEdit();
			popUpAnchor.displayPopUp = false;
		}
		
		protected function filterButton_clickHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		protected function filterButton_mouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		/**
		 *  @private
		 *  Event handler for the <code>dropDownController</code> 
		 *  <code>DropDownEvent.OPEN</code> event.
		 */
		protected function dropDownController_openHandler(event:DropDownEvent):void
		{
			openFilterEditor();
		}
		
		/**
		 *  @private
		 *  Event handler for the <code>dropDownController</code> 
		 *  <code>DropDownEvent.CLOSE</code> event.
		 */
		protected function dropDownController_closeHandler(event:DropDownEvent):void
		{
			closeFilterEditor();
		}
		
	}
}