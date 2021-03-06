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
<cfcomponent output="false" name="ClientRuleScripter_Required" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the required validation.">

	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="selector" type="string" required="no" default="" />
		<cfargument name="locale" type="string" required="no" default="" />

		<cfset var theCondition = "true" />
		<cfset var ConditionDesc = "" />
		<cfset var theScript = "" />
		
		<cfset var DependentInputName = "" />
		<cfset var DependentInputDesc = "" />
		<cfset var DependentInputValue = "" />		
		
		<cfset var valType = getValType() /> 
		<cfset var parameters = arguments.validation.getParameters() />
		<cfset var failureMessage = determineFailureMessage(validation=arguments.validation) />
        
		<!--- Deal with various conditions --->
		<cfif StructKeyExists(arguments.validation.getCondition(),"ClientTest")>
			<cfset theCondition = "function(element) { return #arguments.validation.getCondition().ClientTest# }" />
		<cfelse>			
			<cfif arguments.validation.hasParameter("DependentFieldName")>
				<cfset DependentInputName = arguments.validation.getParameterValue("DependentFieldName") />
			<cfelseif arguments.validation.hasParameter("DependentPropertyName")>
				<cfset DependentInputName = arguments.validation.getParameterValue("DependentPropertyName") />
			</cfif>					
        </cfif>
		
		<cfif arguments.validation.hasParameter('DependentPropertyValue')>
          <cfif isSimpleValue(arguments.validation.getParameterValue('DependentPropertyValue'))>
              <cfif isNumeric(arguments.validation.getParameterValue('DependentPropertyValue'))>
                  <cfset DependentInputValue = "#arguments.validation.getParameterValue('DependentPropertyValue')#" />
              <cfelse>
                  <cfset DependentInputValue = "'#arguments.validation.getParameterValue('DependentPropertyValue')#'" />
              </cfif>
          </cfif>
        </cfif>
		
		<cfif arguments.validation.hasParameter('DependentFieldValue')>
          <cfif isSimpleValue(arguments.validation.getParameterValue('DependentFieldValue'))>
              <cfif isNumeric(arguments.validation.getParameterValue('DependentFieldValue'))>
                  <cfset DependentInputValue = "#arguments.validation.getParameterValue('DependentFieldValue')#" />
              <cfelse>
                  <cfset DependentInputValue = "'#arguments.validation.getParameterValue('DependentFieldValue')#'" />
              </cfif>
          </cfif>
        </cfif>
        
        <cfif len(DependentInputName) GT 0>
            <cfif len(DependentInputValue) gt 0>
                <cfset theCondition = "function(element) { return $("":input[name='#DependentInputName#']"").getValue() == " & DependentInputValue & "; }" />
            <cfelse>
                <cfset theCondition = "function(element) { return $("":input[name='#DependentInputName#']"").getValue().length > 0; }" />
            </cfif>
			
			<cfif arguments.validation.hasParameter("DependentPropertyDesc")>
	            <cfset DependentInputDesc = arguments.validation.getParameterValue("DependentPropertyDesc")>
	        <cfelse>
	            <cfset DependentInputDesc = arguments.validation.getParameterValue("DependentPropertyName",DependentInputName)>
	        </cfif>				
        </cfif>
		
		<cfif len(DependentInputDesc) gt 0>
             <cfif len(DependentInputValue) gt 0>
                <cfset ConditionDesc = " based on what you entered for the " & DependentInputDesc />
            <cfelse>
                <cfset ConditionDesc = " if you specify a value for the " & DependentInputDesc />
            </cfif>
			<cfif len(failureMessage) eq 0>
                <cfset failureMessage = createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# is required#ConditionDesc#.")  />
			</cfif>
    	</cfif>
		
		<cfif Len(failureMessage) eq 0>
            <cfset failureMessage = createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# is required.") />
        </cfif>		
        <cfset failureMessage = variables.Translator.translate(failureMessage,arguments.locale)/>
		
		<cfoutput>
		<cfsavecontent variable="theScript">
		    #arguments.selector#.rules("add", { #valType# : #theCondition#, messages: {#valType#: "#failureMessage#"} });
		</cfsavecontent>
		</cfoutput>		

		<cfreturn trim(theScript) />

	</cffunction>

</cfcomponent>