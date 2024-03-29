<%--
    Mango - Open Source M2M - http://mango.serotoninsoftware.com
    Copyright (C) 2006-2011 Serotonin Software Technologies Inc.
    @author Matthew Lohbihler
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/.
--%>
<%@ include file="/WEB-INF/jsp/include/tech.jsp" %>

<script type="text/javascript">
  function initImpl() {
//      alert("${dataSource.calendarName}");
      gcalGetCalsButton(false);
      option = document.createElement("option");
      if ("${dataSource.calendarName}" != "") {
          option.value = "${dataSource.calendarFeed}";
          option.selected = true;
          $set(option, "${dataSource.calendarName}");
          $("calendarNameSelect").appendChild(option);  	  
      }
//      alert("initImpl");
  }
  
  function gcalGetCals() {
 //    alert("starting gcalGetCals");	  
      $set("gcalGetCalsError", "<fmt:message key="dsEdit.gcal.getCals"/>");
      show("gcalGetCalsError");
      gcalGetCalsButton(true);
//      hide("gcalGetCalsResults");
      hide("calendarNameSelect");
//      dwr.util.removeAllRows("gcalGetCalsResults");
      DataSourceEditDwr.gcalGetCals($get("username"), 
              $get("password"), gcalGetCalsCB);
//      alert("gcalGetCals");
  }

  function gcalGetCalsCB() {
      setTimeout(getCalsUpdate, 1000);
//      alert("gcalGetCalsCB");
  }

  function getCalsUpdate() {
      DataSourceEditDwr.gcalTestStatementUpdate(getCalsUpdateCB);
//      alert("getCalsUpdate");
  }
  
  function clearChildren(node) {
	  while (node.firstChild) {
		  node.removeChild(node.firstChild);
	  }
  }
  
  function getCalsUpdateCB(result) {
      if (result) {
          if (result.error)
              $set("gcalGetCalsError", result.error);
          else {
              hide("gCAlgetCalsError");
/*
var tbody, td, tr, r, c;
              tbody = $("gcalGetCalsResults");
              tr = document.createElement("tr");
              tr.className = "smRowHeader";
              tbody.appendChild(tr);
              for (c=0; c<result.calendars.length; c++) {
                  td = document.createElement("td");
                  $set(td, result.calendars[c]);
                  tr.appendChild(td);
              }
              
              show(tbody);
*/              
              var select, option;
              select = $("calendarNameSelect");
              clearChildren(select);
              for (c=0; c<result.calendars.length; c++) {
                  option = document.createElement("option");
                  var entry = result.calendars[c]
                  option.value = entry.split(":")[1];
                  option.selected = c == 0;
                  $set(option, entry.split(":")[0]);
                  select.appendChild(option);
              }
              
              show(select);
          }
          gcalGetCalsButton(false);
      }
      else
    	  gcalGetCalsCB();
//      alert("getCalsUpdateCB");
  }

  
  function gcalGetCalsButton(testing) {
      setDisabled($("gcalGetCalsButton"), testing);
//      alert("getCalsButton");
  }
  
  function saveDataSourceImpl() {
	  alert($get("calendarNameSelect"));
	  alert(calendarNameSelect.selectedIndex);	  
      DataSourceEditDwr.saveGCalDataSource($get("dataSourceName"), $get("dataSourceXid"), $get("updatePeriods"),
              $get("updatePeriodType"), $get("username"),
              $get("password"), calendarNameSelect.options[calendarNameSelect.selectedIndex].text, $get("calendarNameSelect"), saveDataSourceCB);
//      alert("saveDataSourceImpl");

  }
  
  function writePointListImpl(points) {
  }
  
  function appendPointListColumnFunctions(pointListColumnHeaders, pointListColumnFunctions) {
      pointListColumnHeaders[pointListColumnHeaders.length] = function(td) { td.id = "fieldNameTitle"; };
      pointListColumnFunctions[pointListColumnFunctions.length] = function(p) { return p.pointLocator.fieldName; };
  }
  
  function editPointCBImpl(locator) {
      $set("daysPeriod", locator.daysPeriod);
      $set("timeOverrideName", locator.timeOverrideName);
      $set("dataTypeId", locator.dataTypeId);
  }
  
  function savePointImpl(locator) {
      delete locator.settable;
      
//      locator.fieldName = $get("fieldName");
      locator.timeOverrideName = $get("timeOverrideName");
      locator.daysPeriod = $get("daysPeriod");
      locator.dataTypeId = $get("dataTypeId");
      alert("here");
      
      DataSourceEditDwr.saveGCalPointLocator(currentPoint.id, $get("xid"), $get("name"), locator, savePointCB);
  }
  
</script>

<c:set var="dsDesc"><fmt:message key="dsEdit.gcal.desc"/></c:set>
<c:set var="dsHelpId" value="gcalDS"/>
<%@ include file="/WEB-INF/jsp/dataSourceEdit/dsHead.jspf" %>
        <tr>
          <td class="formLabelRequired"><fmt:message key="dsEdit.updatePeriod"/></td>
          <td class="formField">
            <input type="text" id="updatePeriods" value="${dataSource.updatePeriods}" class="formShort"/>
            <sst:select id="updatePeriodType" value="${dataSource.updatePeriodType}">
              <tag:timePeriodOptions sst="true" s="true" min="true" h="true"/>
            </sst:select>
          </td>
          <td></td>
        </tr>
        
        <tr>
          <td class="formLabelRequired"><fmt:message key="dsEdit.sql.username"/></td>
          <td class="formField"><input id="username" type="text" value="${dataSource.username}"/></td>
          <td></td>
        </tr>
        
        <tr>
          <td class="formLabelRequired"><fmt:message key="dsEdit.sql.password"/></td>
          <td class="formField"><input id="password" type="text" value="${dataSource.password}"/></td>
          <td></td>
        </tr>
        <tr>
          <td class="formLabelRequired"><fmt:message key="dsEdit.sql.select"/></td>
          <td class="formField">
            <select id="calendarNameSelect"></select>
          </td>
          <td>
            <input id="gcalGetCalsButton" type="button" value="<fmt:message key="dsEdit.sql.execute"/>"  onclick="gcalGetCals();"/>
          </td>
        </tr>
<!-- 
        <tr>
          <td class="formLabelRequired"><fmt:message key="dsEdit.sql.select"/></td>
          <td class="formField">
            <input id="calendarName" type="hidden" value="${dataSource.calendarName}"/>
          </td>
        </tr>
 -->        
      </table>
      <tag:dsEvents/>
    </div>
  </td>
  
  <td valign="top">
    <div class="borderDiv marB">
      <table cellspacing="1">    
        <tr><td id="gcalGetCalsError"></td></tr>
<%@ include file="/WEB-INF/jsp/dataSourceEdit/dsFoot.jspf" %>

<tag:pointList pointHelpId="sqlPP">
  <tr>
    <td class="formLabelRequired"><fmt:message key="dsEdit.pointDataType"/></td>
    <td class="formField">
      <select name="dataTypeId">
        <tag:dataTypeOptions excludeImage="true"/>
      </select>
    </td>
  </tr>
  
  <tr>
    <td id="fieldNameLabel" class="formLabelRequired"><fmt:message key="dsEdit.gcal.daysPeriod"/></td>
    <td class="formField"><input type="text" id="daysPeriod" value="0"/></td>
  </tr>
  

<!-- 
 <tr>
    <td class="formLabel"><fmt:message key="dsEdit.gcal.update"/></td>
    <td class="formField"><textarea cols="35" rows="4" name="updateStatement"></textarea></td>
  </tr>
!-->
</tag:pointList>