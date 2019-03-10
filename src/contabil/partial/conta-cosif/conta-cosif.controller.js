(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContaCosifCtrl', ContaCosifCtrl);

    ContaCosifCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ContaCosifCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;

        vm.dgCosifControl = {};
        vm.dgCosifInit = dgCosifInit;
        vm.dgCosifLabel = dgCosifLabel;
        vm.itemClick = itemClick;
        vm.dgCosifConfig = {
            //url: config.REST_URL + '/publish/sms/broker',
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
                field: 'tipoco',
                type: 'varchar'
            }, {
                title: 'Classificação',
                field: 'classco',
                type: 'varchar'
            }, {
                title: 'Natureza',
                field: 'naturez',
                type: 'varchar'
            }]
        };

        function dgCosifInit(event) {
            vm.getData();
        }

        function dgCosifLabel(event) {

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
            vm.dgCosifControl.clearData();
            const TIPO = ['Patrimonial', 'Resultado'];

            const CN = [{
                classco: 'Despesa',
                naturez: 'Devedora'
            }, {
                classco: 'Receita',
                naturez: 'Credora'
            }];

            var data = [];
            for (var i = 0; i <= 49; i++) {

                var r = Math.floor((Math.random() * 2));

                data.push({
                    'codigo': i + 161200013000,
                    'descricao': 'Nome ' + Math.floor((Math.random() * 100000) + 1),
                    'tipoco': TIPO[Math.floor((Math.random() * 2))],
                    'classco': CN[r].classco,
                    'naturez': CN[r].naturez
                });
            }

            vm.dgCosifControl.addDataRows(data);

            //vm.dgCosifControl.getData(vm.filter);
        }

        function create() {
            $state.go('conta-cosif-form');
        }

        function update(id) {
            $state.go('conta-cosif-form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                exampleService.remove(vm.dgCosifControl.selectedItems)
                    .then(function success(response) {
                        console.info(response);
                        if (response.success) {
                            vm.dgCosifControl.removeRow('.selected');
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