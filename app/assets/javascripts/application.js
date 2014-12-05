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
//= require d3
//= require bootstrap-colorpicker
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
                    $scope.watchingStocks
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

var transform = function(key, color, data, transformFunc){
    var myData = { key: key, color: color, values: [] };

    for (var i = 0; i < data.length; i++){
        myData.values.push(transformFunc(data[i], i));
    }

    return myData;
};

var simpleMovingAverageTransform = function(data, numDays, color){
    var sma = [];

    var results = transform("Simple Moving Average (" + numDays + " days)", color, data, function(d, i){
        sma.push(parseFloat(d[4]));
        if(sma.length > numDays){
            sma.shift();
        }

        var total = 0;
        for(var j = 0; j < sma.length; j++){
            total += sma[j];
        }
        console.log(i);

        return {x: i, y:(total / sma.length)};
    });

    return results;
};

myApp.controller(
    'StockChartController', 
    ['$scope', "$http",
        function($scope, $http) {
            var chart = nv.models.lineChart()
                                 .margin({left: 100})
                                 .transitionDuration(350)
                                 .showLegend(true)
                                 .showYAxis(true)
                                 .showXAxis(true);

            chart.xAxis.axisLabel("Date").tickFormat(d3.format('.f'));
            chart.yAxis.axisLabel("Price").tickFormat(d3.format('.02f'));

            $scope.init = function(tickerSymbol) {
                $http.get('/stocks/stock/' + (tickerSymbol) + '.json').success(function (data){
                    $scope.chartList = [];
                    $scope.chartData = data.data;

                    $scope.chartList.push(transform("Stock Prices", '#ff7f0e', $scope.chartData.history, function(d, i){
                        return { x: i, y: parseFloat(d[4])};
                    }));
                    
                    $scope.add = function(){
                        var numDays = parseInt($scope.numDays);
                        var color = $scope.lineColor;

                        $scope.chartList.push(simpleMovingAverageTransform($scope.chartData.history, numDays, color));

                        console.log($scope.chartList);
                        renderChart();
                    };

                    var renderChart = function(){
                        d3.select('#visualization').datum($scope.chartList).call(chart);
                    };

                    renderChart();
                });
            }    
        }
    ]
 );
