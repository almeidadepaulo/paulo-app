(function() {
    'use strict';

    angular.module('seeawayApp').controller('ResumoCtrl', ResumoCtrl);

    ResumoCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ResumoCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;

        vm.dgExemploControl = {};
        vm.dgExemploInit = dgExemploInit;
        vm.dgExemploLabel = dgExemploLabel;
        vm.itemClick = itemClick;
        vm.dgExemploConfig = {
            url: config.REST_URL + '/contabil/resumo',
            method: 'GET',
            fields: [{
                title: 'Conta SICLID',
                field: 'COL_1',
                type: 'varchar'
            }, {
                title: 'Saldo anterior',
                field: 'COL_2',
                type: 'float',
                numeral: '0,0.00'
            }, {
                title: 'Movimentação',
                field: 'COL_3',
                type: 'float',
                numeral: '0,0.00'
            }, {
                title: 'Saldo atual',
                field: 'COL_4',
                type: 'float',
                numeral: '0,0.00'
            }, {
                title: 'Saldo contabilizado',
                field: 'COL_5',
                type: 'float',
                numeral: '0,0.00'
            }, {
                title: 'Base SICLID',
                field: 'COL_6',
                type: 'float',
                numeral: '0,0.00'
            }, {
                title: 'CPPF suspenso',
                field: 'COL_7',
                type: 'varchar'
            }, {
                title: 'Complementar',
                field: 'COL_8',
                type: 'varchar'
            }, {
                title: 'Diferença',
                label: 'diferenca',
                field: 'COL_9',
                type: 'float',
                numeral: '0,0.00'
            }]
        };

        function dgExemploInit(event) {
            vm.getData();
        }

        function dgExemploLabel(event) {
            var n = Math.abs((numeral().unformat(event.data.value.COL_9)).toFixed(2));
            /* jshint ignore:start */
            if (event.item.label === 'diferenca' && n !== 0) {
                //console.info('n', n);

                if (n === 34.36) {
                    event.data.COL_9 = '<div class="diferenca">' + event.data.COL_9 +
                        '<span class="tip">Valores dos lançamentos debitados/creditados diferem dos valores de origem</span></div>';
                } else if (n === 6524.82) {
                    event.data.COL_9 = '<div class="diferenca">' + event.data.COL_9 +
                        '<span class="tip">Inversão de contas contábeis</span></div>';
                } else if (n === 32.31) {
                    event.data.COL_9 = '<div class="diferenca">' + event.data.COL_9 +
                        '<span class="tip">Lançamento em conta não cadastrada</span></div>';
                } else if (n === 492.52) {
                    event.data.COL_9 = '<div class="diferenca">' + event.data.COL_9 +
                        '<span class="tip">Duplicidade de lançamentos</span></div>';
                } else if (n === 5.97) {
                    event.data.COL_9 = '<div class="diferenca">' + event.data.COL_9 +
                        '<span class="tip">Omissão de Lançamento</span></div>';
                } else if (n === 76.80) {
                    event.data.COL_9 = '<div class="diferenca">' + event.data.COL_9 +
                        '<span class="tip">Conta contabil inexistente</span></div>';
                } else if (n === 29.85) {
                    event.data.COL_9 = '<div class="diferenca">' + event.data.COL_9 +
                        '<span class="tip">Saldos diferem do analítico e acumulado</span></div>';
                } else {
                    event.data.COL_9 = '<div class="diferenca">' + event.data.COL_9 +
                        '<span class="tip">Saldos diferem do analítico e acumulado</span></div>';
                }

            };
            /* jshint ignore:end */
            return event;
        }

        function itemClick(event) {
            if (event.itemClick.linkId === 'edit') {
                console.info('itemClick', event);
                vm.update(event.itemClick.value);
            }
        }

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function getData() {
            vm.filter = vm.filter || {};
            vm.filter.data = new Date();

            /*var data = [{
                'contasiclid': '203120244,',
                'conta_cosif': '161200012031',
                'saldo_anterior': 2696026.94,
                'movimentacao': 4788.58,
                'saldo_atual': 2700815.52,
                'saldo_contabilizado': 2700815.52,
                'base_siclid': 2700815.52,
                'diferenca': '-'
            }];

            for (var i = 0; i <= data.length - 1; i++) {
                vm.dgExemploControl.addDataRow(data[i]);
            }

            for (var i = 0; i <= 49; i++) {
                vm.dgExemploControl.addDataRow({
                    'contasiclid': i + 203120200,
                    'conta_cosif': i + 161200013000,
                    'saldo_anterior': (Math.random() * 100000),
                    'movimentacao': (Math.random() * 100000),
                    'saldo_atual': (Math.random() * 100000),
                    'saldo_contabilizado': (Math.random() * 100000),
                    'base_siclid': (Math.random() * 100000),
                    'diferenca': (Math.random() * 100)
                });
            }*/

            vm.dgExemploControl.getData(vm.filter);
        }

        function create() {
            $state.go('conta-siclid-form');
        }

        function update(id) {
            $state.go('conta-siclid-form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                exampleService.remove(vm.dgExemploControl.selectedItems)
                    .then(function success(response) {
                        console.info(response);
                        if (response.success) {
                            vm.dgExemploControl.removeRow('.selected');
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }
    }
})();