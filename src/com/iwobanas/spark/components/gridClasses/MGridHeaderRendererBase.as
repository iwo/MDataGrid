package com.iwobanas.spark.components.gridClasses
{
	import flash.events.MouseEvent;
	
	import spark.components.PopUpAnchor;
	import spark.components.gridClasses.GridItemRenderer;
	
	public class MGridHeaderRendererBase extends GridItemRenderer
	{
		public function MGridHeaderRendererBase()
		{
			super();
		}
		
		[Bindable]
		public var popUpAnchor:PopUpAnchor;
		
		protected function openFilterEditor():void
		{
			var column:MDataGridColumn = this.column as MDataGridColumn;
			if (!column)
				return;
			
			if (!column.filterEditorInstance)
				column.filterEditorInstance = column.filterEditor.newInstance();
			
			popUpAnchor.popUp = column.filterEditorInstance;
			popUpAnchor.displayPopUp = true;
			column.filterEditorInstance.startEdit(column);
		}
		
		protected function closeFilterEditor():void
		{
			var column:MDataGridColumn = this.column as MDataGridColumn;
			if (!column)
				return;
			column.filterEditorInstance.endEdit();
			popUpAnchor.displayPopUp = false;
		}
		
		protected function filterButton_clickHandler(event:MouseEvent):void
		{
			event.stopPropagation();
			
			if (popUpAnchor)
			{
				if (popUpAnchor.displayPopUp)
				{
					closeFilterEditor();
				}
				else
				{
					openFilterEditor();
				}
			}
		}
		
		protected function filterButton_mouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
	}
}