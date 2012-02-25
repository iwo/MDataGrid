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
	import com.iwobanas.utils.WildcardUtils;
	
	/**
	 * The WildcardFilter class defines MDataGrid column filter 
	 * using text wildcard to filter items.
	 * 
	 * This filter matches item labels to a given wildcard 
	 * and if they don't match eliminate items from data provider.
	 * 
	 * If wildcard is not set or is empty string filter is regarded inactive.
	 */
	public class WildcardFilter extends ColumnFilterBase
	{
		/**
		 * Constructor.
		 */
		public function WildcardFilter()
		{
		}
		
		/**
		 * Wildcard to be matched against item labels.
		 * "*" is interpreted as any character sequence.
		 * "?" is interpreted as any single character.
		 * This wildcard is case insensitive.
		 */
		[Bindable]
		public function get wildcard():String
		{
			return _wildcard;
		}
		/**
		 * @private
		 */
		public function set wildcard(value:String):void
		{
			_wildcard = value;
			regExp = WildcardUtils.wildcardToRegExp(value ? value : "");
			commitFilterChange();
		}
		/**
		 * @private
		 * Storage variable for wildcard property.
		 */
		protected var _wildcard:String;
		
		/**
		 * Current wildcard converted to regular expression.
		 */
		[Bindable]
		public var regExp:RegExp;
		
		[Bindable("filterValueChange")]
		/**
		 * Flag indicating wether this filter is active 
		 * i.e may eliminate some items from MDataGrid data provider.
		 */
		override public function get isActive():Boolean
		{
			return (_wildcard != null && _wildcard != "");
		}
		
		/**
		 * Reset filter so that it will not filter out any items.
		 * After call to this function filter becomes inactive <code>isActive = false</code>.
		 */
		override public function resetFilter():void
		{
			wildcard = "";
		}
		
		/**
		 * Test if given MDataGrid item should remain in MDataGrid data provider.
		 */
		override public function filterFunction(obj:Object):Boolean
		{
			if (!regExp)
			{
				return true;
			}
			return regExp.test(column.itemToLabel(obj));
		}
		
	}
}