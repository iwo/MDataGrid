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
package com.iwobanas.utils
{
	/**
	 * The WildcardUtils class is an all-static class with methods for working with wildcards.
	 * You do not create instances of WildcardUtils; instead you simply call static methods such as the WildcardUtils.wildcardToRegExp() method.
	 */ 
	public class WildcardUtils
	{
		/**
		 * Convert wildcard string to regular expression.
		 * 
		 * @param wildcard wildcard string to be converted to regular expression
		 * @param flags flags used to create regular expression (see RegExp documentation)
		 * @param asterisk whether asterisk is interpreted as any character sequence
		 * @param questionMark whether question mark is interpreted as any character
		 * 
		 * @return regular expression equivalent to passed wildcard
		 */
		public static function wildcardToRegExp(wildcard:String, flags:String = "i", asterisk:Boolean = true, questionMark:Boolean = true):RegExp
		{
			var resultStr:String;

			//excape metacharacters other than "*" and "?"
			resultStr = wildcard.replace(/[\^\$\\\.\+\(\)\[\]\{\}\|]/g, "\\$&");

			//replace wildcard "?" with reg exp equivalent "."
			resultStr = resultStr.replace(/[\?]/g, ".");

			//replace wildcard "*" with reg exp equivalen ".*?"
			resultStr = resultStr.replace(/[\*]/g, ".*?");
			
			return new RegExp(resultStr, flags);
		}
		
	}
}