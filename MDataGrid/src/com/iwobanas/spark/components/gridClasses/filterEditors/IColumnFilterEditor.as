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
package com.iwobanas.spark.components.gridClasses.filterEditors
{
	import com.iwobanas.spark.components.gridClasses.MDataGridColumn;
	
	import mx.core.IUIComponent;
	
	/**
	 * The IColumnFilterEditor defines interface of all column filter editors.
	 * Column filter editors are used to modify MDataGrid column filters.
	 * 
	 * @see com.iwobanas.spark.components.gridClasses.filters.ColumnFilterBase
	 * @see com.iwobanas.spark.components.gridClasses.filterEditors.FilterEditorBase
	 */
	public interface IColumnFilterEditor extends IUIComponent
	{

		
		/**
		 * Start editing filter for the given column.
		 * Implementation of this function should update MDataGridColumn 
		 * <code>editorInstance</code> property.
		 * 
		 * <p>Typically concrete editors also check the type of columns 
		 * <code>filter</code> property and create new filter if needed.</p>
		 */
		function startEdit(column:MDataGridColumn):void;
		
		
		/**
		 * End editing filter for the given column.
		 * Implementation of this column should also set MDataGridColumn 
		 * <code>editorInstance</code> property to null.
		 * 
		 * <p>Ending editing the filter does not mean that the filter should be deactivated. 
		 * Only the editor component should be closed.</p>
		 */
		function endEdit():void;
		
	}
}