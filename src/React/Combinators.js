/* global exports */
"use strict";

exports.createElementNoChildren = function(tagname) {
  return function(props){
    return React.createElement(tagname,props);
  };
};

exports.getParameterByName_ = function(name) {
  return function(){
    var url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  }
};

exports.onPopState = function(f){
  return function(){
    window.onpopstate = f;
  }
};

exports.logAnything = function(x){
  return function(){
    return console.log('%o',x);
  }
};

exports.setTimeout = function(action) {
  return function(ms) {
    return function() {
      return setTimeout(function(){
        action();
      }, ms);
    }
  }
};

exports.getPathPieces = function(){
  var pieces = window.location.pathname.split("/").slice(1);
  for (var i =0 ; i < pieces.length; i++){
    pieces[i] = decodeURIComponent(pieces[i]);
  }
  return pieces;
};

exports.setPathPieces = function(title){
  return function(pieces){
    for (var i =0 ; i < pieces.length; i++){
      pieces[i] = encodeURIComponent(pieces[i]);
    }
    return function(){
      history.pushState({}, title, "/" + pieces.join("/"));
    };
  };
};
