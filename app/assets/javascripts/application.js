// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require angular
//= require_tree .

var myApp = angular.module('myApp',[]);
myApp.controller(
	'WatchingStocksController', 
	['$scope', "$http",
	    function($scope, $http) {
            $scope.watchingStocks = [];
            
            var refreshStockData = function() {
				$http.get('/stocks.json').success(function (data){
	            	$scope.watchingStocks = data.data;
	            	console.log(data);
	            });
            };

            refreshStockData();

            $scope.add = function() {
            	if ($scope.newStock !== "") {
            		$http.post('/stocks.json', '{"stock":{"ticker_symbol":"' +  $scope.newStock + '"}}');
         			refreshStockData();
         		}
	        }
        }
    ]
 );
