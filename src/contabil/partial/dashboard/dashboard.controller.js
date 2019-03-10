(function() {
    'use strict';

    angular.module('seeawayApp').controller('DashboardCtrl', DashboardCtrl);

    DashboardCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog', '$timeout'];

    function DashboardCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog, $timeout) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.filter.ano = [2010, 2011, 2012, 2013, 2014, 2015, 2016];
        vm.filter.anoSelected = new Date().getFullYear();
        vm.filter.mes = moment.months();
        vm.filter.mesSelected = vm.filter.mes[new Date().getMonth()];
        vm.anoChange = anoChange;
        vm.mesChange = mesChange;
        vm.lineOnClick = lineOnClick;

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });



        function init() {
            $timeout(function() {
                getData();
            }, 100);
        }

        function anoChange() {
            getData();
        }

        function mesChange() {
            getDataPie();
        }

        function getData() {
            vm.line = {};
            vm.line.labels = moment.months();
            vm.line.series = ['Ocorrências'];
            var data = [];
            for (var i = 0; i < 12; i++) {
                data.push(Math.floor((Math.random() * 100) + 1));
            }
            vm.line.data = [data];

            getDataPie();
        }

        function lineOnClick(points, evt) {
            //console.info('points', points);
            //console.info('evt', evt);
            getDataPie();
        }

        function getDataPie() {
            vm.pie = {};
            vm.pie.labels = ['Valores dos lançamentos diferem dos valores de origem',
                'Inversão de contas contábeis',
                'Lançamento em conta não cadastrada',
                'Duplicidade de lançamentos',
                'Omissão de lançamento',
                'Conta contábil inexistente',
                'Controle da conta contábil não confere'
            ];
            var data = [];
            for (var j = 0; j < vm.pie.labels.length; j++) {
                data.push(Math.floor((Math.random() * 30) + 1));
            }
            vm.pie.data = data;
            vm.pie.options = {
                legend: {
                    display: true,
                    position: 'top'
                },
                tooltips: {
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
                }
            };
            $scope.$apply();
        }

    }
})();