var tm, labelType, useGradients, nativeTextSupport, animate;
var visualizationType = "slice-and-dice";

function displayTreeMap(json) {
    if(tm) {
        $("#infovis").remove();
        $("#infovis-container").append("<div id='infovis'></div>");
    }
    tm = new $jit.TM.Squarified({
    injectInto: 'infovis',
    titleHeight: 40,
    animate: animate,
    offset: 1,
    Events: {
      enable: true,
      onClick: function(node) {
        if(node) tm.enter(node);
      },
      onRightClick: function() {
        tm.out();
      }
    },
    duration: 1000,
    Tips: {
      enable: true,
      offsetX: -200,
      offsetY: 10,
      onShow: function(tip, node, isLeaf, domElement) {
        var html = "<div class=\"tip-title\"><h4>" + node.name  + "</h4></div><br/>";
        var data = node.data;
        if(data.nbRacks) {
          html += "nbRacks: " + data.nbRacks + "<br/>";
        }
        if(data.nbNodes) {
          html += "nbNodes: " + data.nbNodes + "<br/>";
        }
        if (data.ip) {
          html += "Ip: " + data.ip + "<br/>";
        }
        if (data.token) {
          html += "Token: " + data.token + "<br/>";
        }
        if (data.owns) {
          html += "Owns: " + data.owns + "<br/>";
        }
        if (data.state) {
          html += "State: " + data.state + "<br/>";
        }
        if (data.status) {
          html += "Status: " + data.status + "<br/>";
        }
        if (data.load) {
          html += "Load: " + data.load + "<br/>";
        }
        
        tip.innerHTML =  html; 
      }  
    },
    onCreateLabel: function(domElement, node){
        domElement.innerHTML = node.name;
        var style = domElement.style;
        style.display = '';
        style.border = '1px solid transparent';
        domElement.onmouseover = function() {
          style.border = '1px solid #black';
        };
        domElement.onmouseout = function() {
          style.border = '1px solid transparent';
        };
    }
  });
  
  tm.loadJSON(json);
  var util = $jit.util;
  
  if (visualizationType == "slice-and-dice") {
      util.extend(tm, new $jit.Layouts.TM.SliceAndDice);
      tm.layout.orientation = "v";
  } else if (visualizationType == "squarified") {
    util.extend(tm, new $jit.Layouts.TM.Squarified);
    tm.layout.orientation = "h";
  } else if (visualizationType == "strip") {
    util.extend(tm, new $jit.Layouts.TM.Strip);
    tm.layout.orientation = "v";
  } 
  
  tm.refresh();
  
  //add events to radio buttons
  var sq = $jit.id('r-sq'),
      st = $jit.id('r-st'),
      sd = $jit.id('r-sd');
  util.addEvent(sq, 'click', function() {
    visualizationType = "squarified";
    displayTreeMap(json);
  });
  util.addEvent(st, 'click', function() {
    visualizationType = "strip";
    displayTreeMap(json);
  });
  util.addEvent(sd, 'click', function() {
    visualizationType = "slice-and-dice";
    displayTreeMap(json);
  });
  var back = $jit.id('r-back');
  if (back) {
      $jit.util.addEvent(back, 'click', function() {
        tm.out();
      });
  }
}