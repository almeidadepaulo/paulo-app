(function() {
    'use strict';

    angular.module('seeawayApp').controller('ExampleCtrl', ExampleCtrl);

    ExampleCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ExampleCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog) {

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
            url: config.REST_URL + '/example',
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
                title: 'ID',
                field: '_id',
                type: 'int'
            }, {
                title: 'Nome',
                field: 'nome',
                type: 'varchar'
            }, {
                title: 'CPF',
                field: 'cpf',
                type: 'varchar',
                stringMask: '###.###.###-##'
            }, {
                title: 'Data',
                field: 'data',
                type: 'date',
                moment: 'dddd - DD/MM/YYYY'
            }, {
                class: 'fa fa-battery-empty',
                icon: '',
                title: 'Label Function',
                field: 'bateria',
                type: 'int',
                label: 'bateria',
                align: 'center'
            }, {
                title: 'Status',
                field: 'status',
                type: 'int',
                label: 'status',
                align: 'center'
            }]
        };

        function dgExemploInit(event) {
            vm.getData();
        }

        function dgExemploLabel(event) {
            if (event.item.label === 'bateria') {
                event.item.class = 'fa fa-battery-' + event.data.bateria;
            } else if (event.item.label === 'status') {
                if (event.data.status === 1) {
                    event.data.status = '<span class="label label-success">ATIVO</span>';
                } else {
                    event.data.status = '<span class="label label-warning">PENDENTE</span>';
                }
            }

            return event;
        }

        function itemClick(event) {
            if (event.itemClick.linkId === 'edit') {
                console.info('itemClick', event);
                vm.update(event.itemClick._id);
            }
        }

        /*$scope.$on('', function() {
            
        });*/

        function getData() {
            console.info('$rootScope.current', $rootScope.current);
            vm.dgExemploControl.getData();
        }

        function create() {
            $state.go('example.form');
        }

        function update(id) {
            $state.go('example.form', { id: id });
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