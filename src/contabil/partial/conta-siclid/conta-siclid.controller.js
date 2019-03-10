(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContaSiclidCtrl', ContaSiclidCtrl);

    ContaSiclidCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ContaSiclidCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog) {

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
            //url: config.REST_URL + '/',
            method: 'GET',
            fields: [{
                link: true,
                linkId: 'edit',
                title: '',
                class: 'fa fa-pencil',
                icon: '',
                value: '',
                align: 'center'
            }, {
                title: 'Código',
                field: 'codigo',
                type: 'int'
            }, {
                title: 'Descrição',
                field: 'descricao',
                type: 'varchar'
            }, {
                title: 'Tipo Conta',
                field: 'tipocs',
                type: 'varchar'
            }, {
                title: 'Classificação',
                field: 'classcs',
                type: 'varchar'
            }, {
                title: 'Natureza',
                field: 'natureza',
                type: 'varchar'
            }]
        };

        function dgExemploInit(event) {
            vm.getData();
        }

        function dgExemploLabel(event) {

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
            vm.dgExemploControl.clearData();

            const TIPO = ['Patrimonial', 'Resultado'];

            const CN = [{
                classcs: 'Despesa',
                natureza: 'Devedora'
            }, {
                classcs: 'Receita',
                natureza: 'Credora'
            }];

            var data = [];
            for (var i = 0; i <= 49; i++) {

                var r = Math.floor((Math.random() * 2));

                data.push({
                    'codigo': i + 203120200,
                    'descricao': 'Nome ' + Math.floor((Math.random() * 100000) + 1),
                    'tipocs': TIPO[Math.floor((Math.random() * 2))],
                    'classcs': CN[r].classcs,
                    'natureza': CN[r].natureza
                });
            }

            vm.dgExemploControl.addDataRows(data);

            //vm.dgExemploControl.getData(vm.filter);
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