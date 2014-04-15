<cfcomponent displayName="General Utility functions">

	<cfscript>
		/**
		 * ========== Ian's comments ==========
		 * Example: niceTrim(str, 50)
		 *
		 * ========== ORIGINAL COMMENTS FROM AUTHOR ==========
		 * An enhanced version of left() that doesn't cut words off in the middle.
		 * Minor edits by Rob Brooks-Bilson (rbils@amkor.com) and Raymond Camden (rbils@amkor.comray@camdenfamily.com)
		 *
		 * Updates for version 2 include fixes where count was very short, and when count+1 was a space. Done by RCamden.
		 *
		 * @param str      String to be checked.
		 * @param count      Number of characters from the left to return.
		 * @return Returns a string.
		 * @author Marc Esher (rbils@amkor.comray@camdenfamily.comjonnycattt@aol.com)
		 * @version 2, April 16, 2002
		 *
		 * For more see;
		 * http://www.cflib.org/udf.cfm/fullleft
		 * http://www.raymondcamden.com/index.cfm/2008/5/28/Ask-a-Jedi-Best-way-to-trim-text
		 */
		
		
		function fullLeft(str, count) {
		    if (not refind("[[:space:]]", str) or (count gte len(str)))
		        return Left(str, count);
		    else if(reFind("[[:space:]]",mid(str,count+1,1))) {
		          return left(str,count);
		    } else {
		        if(count-refind("[[:space:]]", reverse(mid(str,1,count)))) return Left(str, (count-refind("[[:space:]]", reverse(mid(str,1,count)))));
		        else return(left(str,1));
		    }
		}
		
		
		/* Added by Ian to add ellipsis if longer than 'count'  */
		function niceTrim(str, count) {
			var new_str = fullLeft(str, count);
		
			if (len(str) gt count) {
				new_str &= "...";
			}
		
			return new_str;
		}
	</cfscript>


</cfcomponent>