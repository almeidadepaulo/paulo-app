(function() {
    'use strict';

    angular.module('seeawayApp').controller('SiclidXcosifCtrl', SiclidXcosifCtrl);

    SiclidXcosifCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SiclidXcosifCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog) {

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
                title: 'Conta SICLID',
                field: 'contasi',
                type: 'int'
            }, {
                link: true,
                linkId: 'depara',
                title: '',
                class: 'fa fa-exchange',
                icon: '',
                value: '',
                align: 'center'
            }, {
                title: 'Conta COSIF',
                field: 'contaco',
                type: 'int'
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

            var data = [];
            for (var i = 0; i <= 49; i++) {
                data.push({
                    'contasi': i + 203120200,
                    'contaco': i + 161200013000
                });
            }

            vm.dgExemploControl.addDataRows(data);

            //vm.dgExemploControl.getData(vm.filter);
        }

        function create() {
            $state.go('siclid-x-cosif-form');
        }

        function update(id) {
            $state.go('siclid-x-cosif-form', { id: id });
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