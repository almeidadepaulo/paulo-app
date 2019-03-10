(function() {
    'use strict';

    angular.module('seeawayApp').controller('DashboardCtrl', DashboardCtrl);

    DashboardCtrl.$inject = ['dashboardService', '$scope', '$state', '$mdDialog', '$timeout'];

    function DashboardCtrl(dashboardService, $scope, $state, $mdDialog, $timeout) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;

        function init() {

            vm.filter.ano = vm.filter.ano || moment().year();

            // fake            
            // Entrada
            vm.bar1 = {};

            vm.bar1.labels = moment.months();
            vm.bar1.series = ['Entrada', 'Pagos', 'Baixados', 'Em aberto'];
            vm.bar1.colors = [{
                backgroundColor: '#97BBCD',
                //pointBackgroundColor:'',
                //pointHoverBackgroundColor:'',
                borderColor: '#97BBCD',
                //pointBorderColor: '#fff',
                //pointHoverBorderColor:'"
            }, {
                backgroundColor: '#47AB4B',
                //pointBackgroundColor:'',
                //pointHoverBackgroundColor:'',
                borderColor: '#47AB4B',
                //pointBorderColor: '#fff',
                //pointHoverBorderColor:'"
            }, {
                backgroundColor: '#F7973E',
                //pointBackgroundColor:'',
                //pointHoverBackgroundColor:'',
                borderColor: '#F7973E',
                //pointBorderColor: '#fff',
                //pointHoverBorderColor:'"
            }, {
                backgroundColor: '#FB404B',
                //pointBackgroundColor:'',
                //pointHoverBackgroundColor:'',
                borderColor: '#FB404B',
                //pointBorderColor: '#fff',
                //pointHoverBorderColor:'"
            }];

            vm.pie1 = {};
            vm.bar1.options = {
                legend: {
                    display: true
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {

                            var item = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];

                            return ' ' + numeral(item).format('0,0'); //+ ' títulos';
                        }
                    },
                }
            };

            vm.pie1.options = {
                legend: {
                    display: true
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {

                            var item = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];

                            return ' ' + numeral(item).format('0,0'); //+ ' títulos';*/
                        }
                    },
                }
            };

            vm.bar2 = {};

            vm.bar2.labels = moment.months();
            vm.bar2.series = ['Entrada', 'Pagos', 'Baixados', 'Em aberto'];
            vm.bar2.colors = [{
                backgroundColor: '#97BBCD',
                //pointBackgroundColor:'',
                //pointHoverBackgroundColor:'',
                borderColor: '#97BBCD',
                //pointBorderColor: '#fff',
                //pointHoverBorderColor:'"
            }, {
                backgroundColor: '#47AB4B',
                //pointBackgroundColor:'',
                //pointHoverBackgroundColor:'',
                borderColor: '#47AB4B',
                //pointBorderColor: '#fff',
                //pointHoverBorderColor:'"
            }, {
                backgroundColor: '#F7973E',
                //pointBackgroundColor:'',
                //pointHoverBackgroundColor:'',
                borderColor: '#F7973E',
                //pointBorderColor: '#fff',
                //pointHoverBorderColor:'"
            }, {
                backgroundColor: '#FB404B',
                //pointBackgroundColor:'',
                //pointHoverBackgroundColor:'',
                borderColor: '#FB404B',
                //pointBorderColor: '#fff',
                //pointHoverBorderColor:'"
            }];

            vm.pie2 = {};
            vm.bar2.options = {
                legend: {
                    display: true
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {

                            var item = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];

                            return ' ' + numeral(item).format('$ 0,0.00');
                        }
                    },
                }
            };

            vm.pie2.options = {
                legend: {
                    display: true
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {

                            var item = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];

                            return ' ' + numeral(item).format('$ 0,0.00');
                        }
                    },
                }
            };

            $timeout(function() {
                getData();
            }, 1000);
        }

        function getData() {

            vm.loading = true;

            if (vm.filter.ano === '') {
                vm.filter.ano = moment().year();
            }

            vm.filter.refresh = angular.copy(vm.filter);

            var entradaQuantidade = [];
            var entradaValor = [];

            var pagoQuantidade = [];
            var pagoValor = [];

            var baixaQuantidade = [];
            var baixaValor = [];

            dashboardService.collectGetEntrada(vm.filter)
                .then(function success(response) {
                    console.info('collectGetEntrada', response);

                    entradaQuantidade = [];

                    for (var i = 0; i <= 11; i++) {

                        if (response.queryEntrada[i]) {
                            entradaQuantidade.push(response.queryEntrada[i].QUANTIDADE);
                            entradaValor.push(response.queryEntrada[i].VALOR);
                        } else {
                            entradaQuantidade.push(0);
                            entradaValor.push(0);
                        }

                        if (response.queryPago[i]) {
                            pagoQuantidade.push(response.queryPago[i].QUANTIDADE);
                            pagoValor.push(response.queryPago[i].VALOR);
                        } else {
                            pagoQuantidade.push(0);
                            pagoValor.push(0);
                        }

                        if (response.queryBaixa[i]) {
                            baixaQuantidade.push(response.queryBaixa[i].QUANTIDADE);
                            baixaValor.push(response.queryBaixa[i].VALOR);
                        } else {
                            baixaValor.push(0);
                            baixaValor.push(0);
                        }

                    }

                    vm.bar1.data = [entradaQuantidade, pagoQuantidade, baixaQuantidade];
                    vm.bar2.data = [entradaValor, pagoValor, baixaValor];

                    //queryTituloCarteira
                    vm.pie1.labels = [];
                    vm.pie1.data = [];

                    vm.pie2.labels = [];
                    vm.pie2.data = [];

                    for (var j = 0; j <= response.queryTituloCarteira.length - 1; j++) {

                        var porcentagem = response.queryTituloCarteira[j].QUANTIDADE * 100 / response.tituloCarteiraQuantidade;
                        porcentagem = numeral(porcentagem / 100).format('0.00%');

                        vm.pie1.labels.push(response.queryTituloCarteira[j].CARTEIRA + ' (' + porcentagem + ')');
                        vm.pie1.data.push(response.queryTituloCarteira[j].QUANTIDADE);

                        porcentagem = response.queryTituloCarteira[j].VALOR * 100 / response.tituloCarteiraValor;
                        porcentagem = numeral(porcentagem / 100).format('0.00%');

                        vm.pie2.labels.push(response.queryTituloCarteira[j].CARTEIRA + ' (' + porcentagem + ')');
                        vm.pie2.data.push(response.queryTituloCarteira[j].VALOR);
                    }

                    var tag = response.tag;

                    vm.tags = [{ value: numeral(tag).format('0.0 a') },
                        { value: numeral(tag * 95).format('0.0 a') },
                        { value: numeral(tag / 9).format('0.0 a') }
                    ];

                    vm.loading = false;
                }, function error(response) {
                    console.error('collectGetEntrada', response);
                    vm.loading = false;
                });
        }
    }
})();