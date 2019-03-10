(function() {
    'use strict';

    angular.module('seeawayApp').controller('DashboardCtrl', DashboardCtrl);

    DashboardCtrl.$inject = ['config', 'getBoletoStatus', '$rootScope', '$scope', '$state', '$mdDialog', 'pxStringUtil'];

    function DashboardCtrl(config, getBoletoStatus, $rootScope, $scope, $state, $mdDialog, pxStringUtil) {

        var vm = this;
        vm.hello = 'Olá ' + $rootScope.globals.currentUser.nome;
        vm.getBoletoStatus = getBoletoStatus;

        // Gráfico de quantidade
        vm.chartQtd = {};
        // Labels
        vm.chartQtd.labels = ['Boleto(s) vencido(s)',
            'Boleto(s) aberto(s)',
            'Boleto(s) pago(s)',
        ];
        // Valores
        vm.chartQtd.data = [vm.getBoletoStatus.query.CB210_QT_VCTO,
            vm.getBoletoStatus.query.CB210_QT_ABERTO,
            vm.getBoletoStatus.query.CB210_QT_PAGO
        ];
        // Cores
        vm.chartQtd.colors = ['#FF2626', // Vencido
            '#FF9326', // Em aberto
            '#468847' // Pago
        ];
        vm.chartQtd.options = {
            legend: {
                display: false
            }
        };

        // Gráfico de valores
        vm.chartValor = {};
        // Labels
        vm.chartValor.labels = [numeral(vm.getBoletoStatus.query.CB210_VL_VCTO).format('$ 0,0.00'),
            numeral(vm.getBoletoStatus.query.CB210_VL_ABERTO).format('$ 0,0.00'),
            numeral(vm.getBoletoStatus.query.CB210_VL_PAGO).format('$ 0,0.00')
        ];
        // Valores
        vm.chartValor.data = [vm.getBoletoStatus.query.CB210_VL_VCTO,
            vm.getBoletoStatus.query.CB210_VL_ABERTO,
            vm.getBoletoStatus.query.CB210_VL_PAGO
        ];
        // Cores
        vm.chartValor.colors = ['#FF2626', // Vencido
            '#FF9326', // Em aberto
            '#468847' // Pago
        ];
        vm.chartValor.options = {
            tooltips: {
                callbacks: {
                    label: function(tooltipItem, data) {
                        return false;
                    }
                },
            }
        };
    }
})();