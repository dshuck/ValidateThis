<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
--->
<cfcomponent extends="validatethis.tests.BaseTestCase" output="false">
	
	<cfset ClientValidator = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig);
			validation = {clientFieldName="clientFieldName",condition=structNew(),formName="formName",parameters=structNew(),propertyDesc="propertyDesc",propertyName="propertyName",valType="required"};
			validations = [validation];
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="ClientScriptWritersShouldBeLoadedCorrectly" access="public" returntype="void">
		<cfscript>
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.jQuery).name CONTAINS "ClientScriptWriter_jQuery");
			assertTrue(StructKeyExists(ClientScriptWriters.jQuery,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="ExtraClientScriptWriterShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraClientScriptWriterComponentPaths="validatethis.tests.Fixture.ClientScriptWriters.newCSW";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.newCSW).name CONTAINS "ClientScriptWriter_newCSW");
			assertTrue(StructKeyExists(ClientScriptWriters.newCSW,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="OverrideClientScriptWritersShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraClientScriptWriterComponentPaths="validatethis.tests.Fixture.ClientScriptWriters.newCSW,validatethis.tests.Fixture.ClientScriptWriters.jQuery";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.jQuery).name CONTAINS "Fixture");
			assertTrue(StructKeyExists(ClientScriptWriters.jQuery,"generateValidationScript"));
			assertTrue(GetMetadata(ClientScriptWriters.newCSW).name CONTAINS "ClientScriptWriter_newCSW");
			assertTrue(StructKeyExists(ClientScriptWriters.newCSW,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="getValidationScriptShouldHonourPassedInFormName" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery");
			assertTrue(script contains "$form_testFormName = jQuery(""##testFormName"");");
			assertTrue(script contains "$form_testFormName.validate({ignore:'.ignore'});");
			assertTrue(script contains "if ($form_testFormName.find("":input[name='clientFieldName']"").length)");
			assertTrue(script contains "$form_testFormName.find("":input[name='clientFieldName']"").rules");
		</cfscript>  
	</cffunction>

	<cffunction name="getValidationScriptShouldAllowForAnObjectToBePassedInAndUsedInAnExpressionTypeParameter" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			parameter = {name="list",value="getList()",type="expression"};
			parameters = {list=parameter};
			validation = {clientFieldName="clientFieldName",condition=structNew(),formName="formName",parameters=parameters,propertyDesc="propertyDesc",propertyName="propertyName",valType="inList"};
			validations = [validation];
			theObject = mock();
			theObject.evaluateExpression("getList()").returns("1,2");
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery",theObject=theObject);
			assertTrue(script contains "$form_testFormName = jQuery(""##testFormName"");");
			assertTrue(script contains "$form_testFormName.validate({ignore:'.ignore'});");
			assertTrue(script contains "if ($form_testFormName.find("":input[name='clientFieldName']"").length)");
			assertTrue(script contains "$form_testFormName.find("":input[name='clientFieldName']"").rules");
			assertTrue(script contains "rules('add',{inlist: {""list"":""1,2""},messages:{inlist:'The propertyDesc was not found in list: (1,2).'}});");
		</cfscript>  
	</cffunction>

</cfcomponent>

