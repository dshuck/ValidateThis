<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" hint="I am a fixture emulating an extra file reader.">

	<cffunction name="init" returnType="any" access="public" output="false">
		<cfargument name="FileSystem" type="any" required="true" />
		<cfargument name="defaultFormName" type="string" required="true" />

		<cfset variables.FileSystem = arguments.FileSystem />
		<cfset variables.defaultFormName = arguments.defaultFormName />
		<cfreturn this />
	</cffunction>
	
</cfcomponent>
	

