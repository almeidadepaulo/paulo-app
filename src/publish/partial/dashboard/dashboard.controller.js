(function() {
    'use strict';

    angular.module('seeawayApp').controller('DashboardCtrl', DashboardCtrl);

    DashboardCtrl.$inject = ['dashboardService', 'pxDateUtil', '$scope', '$state', '$mdDialog', '$timeout'];

    function DashboardCtrl(dashboardService, pxDateUtil, $scope, $state, $mdDialog, $timeout) {

        var moment = pxDateUtil.moment;
        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.filter.ano = [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017];
        vm.filter.anoSelected = new Date().getFullYear();
        vm.filter.mes = moment.months();
        vm.filter.mesSelected = vm.filter.mes[new Date().getMonth()];
        vm.anoChange = anoChange;
        vm.diaChange = diaChange;
        vm.lineOnClick = lineOnClick;
        vm.line = {};
        vm.line.options = {
            legend: {
                display: true,
                position: 'top'
            }
        };
        vm.colors = ['#97BBCD', '#FDB45C'];


        function init() {
            vm.filter.date = new Date();
            $timeout(function() {
                getData();
                getDataPie();
            }, 100);
        }

        function anoChange() {
            getData();
        }

        function diaChange() {
            getDataPie();
        }

        function getData() {
            vm.line.labels = moment.months();
            vm.line.series = ['SMS', 'E-mail'];
            var data = [];
            var data2 = [];
            vm.line.data = [];

            var params = {
                ano: vm.filter.anoSelected
            };

            dashboardService.mes(params)
                .then(function success(response) {
                    //console.info('success', response);
                    data = [];
                    data2 = [];
                    for (var i = 0; i <= 11; i++) {
                        if (response.querySms[i]) {
                            data.push(response.querySms[i].QTD);
                        } else {
                            data.push(0);
                        }

                        if (response.queryEmail[i]) {
                            data2.push(response.queryEmail[i].QTD);
                        } else {
                            data2.push(0);
                        }
                    }

                    //console.info('data', data);
                    //console.info('data2', data2);

                    vm.line.data = [data, data2];
                }, function error(response) {
                    console.error('error', response);
                });

            //getDataPie();
        }

        function lineOnClick(points, evt) {
            //console.info('points', points);
            //console.info('evt', evt);
            getDataPie();
        }

        function getDataPie() {
            vm.pie = {};
            vm.pie.labels = ['SMS',
                'E-mail'
            ];
            vm.pie.options = {
                legend: {
                    display: false,
                    position: 'top',
                },
                /*tooltips: {
                    enabled: false,
                    custom: function(tooltip) {
                        var tooltipEl = $('#pie-tooltip');

                        if (!tooltip.body) {
                            tooltipEl.css({
                                opacity: 0
                            });
                            return;
                        }

                        //tooltipEl.removeClass('above below');
                        //tooltipEl.addClass(tooltip.yAlign);

                        var color = tooltip.labelColors[0].backgroundColor.replace('0.2', '1');
                        //var innerHtml = '<i class="fa fa-square" aria-hidden="true" style="color:' + color + ';"></i><span>' + tooltip.body[0].lines[0] + '</span>';
                        var innerHtml = '<span>' + tooltip.body[0].lines[0] + '</span>';
                        tooltipEl.html(innerHtml);
                        //console.info(tooltip);
                        tooltipEl.css({
                            opacity: 1,
                            left: tooltip.x + 'px',
                            backgroundColor: tooltip.labelColors[0].backgroundColor.replace('0.2', '1'),
                            //fontFamily: tooltip._bodyFontFamily,
                            //fontSize: tooltip.fontSize,
                            //fontStyle: tooltip.fontStyle
                        });
                    }
                }*/
            };

            var params = {
                date: vm.filter.date
            };
            var data = [];

            dashboardService.dia(params)
                .then(function success(response) {
                    //console.info(response);
                    if (response.querySms[0]) {
                        data[0] = response.querySms[0].QTD;
                    } else {
                        data[0] = null;
                    }
                    if (response.queryEmail[0]) {
                        data[1] = response.queryEmail[0].QTD;
                    } else {
                        data[1] = null;
                    }
                    vm.pie.data = data;
                }, function error(response) {
                    console.error('error', response);
                });
        }
    }
})();